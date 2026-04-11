#!/bin/bash
# check-siyuan-edits.sh — Detect human edits in Siyuan since last Git sync
# Direction: Siyuan → stdout (read-only, changes nothing)
# Trigger: session-start ritual, before any work begins
#
# Prerequisites: sync-to-siyuan.sh must use diff-before-write (only updates
# docs whose content actually changed). This ensures that Siyuan timestamps
# on unchanged docs remain stable — so any doc with a timestamp newer than
# the last Git commit was edited by a human directly in Siyuan.
#
# Detects:
#   1. Existing docs modified by human (timestamp > last Git commit)
#   2. New docs created by human in Siyuan (no Git counterpart)
#
# Output: human-readable report. Exit: 0 = edits found, 1 = none, 2 = error
#
# Credentials: same .env as sync-to-siyuan.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
ENV_FILE="$REPO_DIR/.env"
if [ -f "$ENV_FILE" ]; then
    # shellcheck disable=SC1090
    source "$ENV_FILE"
fi

SIYUAN_URL="${SIYUAN_URL:-}"
SIYUAN_TOKEN="${SIYUAN_TOKEN:-}"
NOTEBOOK_ID="${SIYUAN_NOTEBOOK_ID:-}"

if [[ -z "$SIYUAN_URL" || -z "$SIYUAN_TOKEN" || -z "$NOTEBOOK_ID" ]]; then
    echo "ERROR: SIYUAN_URL, SIYUAN_TOKEN, and SIYUAN_NOTEBOOK_ID must be set."
    exit 2
fi

AUTH="Authorization: Token $SIYUAN_TOKEN"
CT="Content-Type: application/json"

siyuan_api() {
    curl -s "$SIYUAN_URL/api/$1" -H "$AUTH" -H "$CT" -d "$2"
}

# Check Siyuan is reachable
if ! curl -s -o /dev/null -w "%{http_code}" "$SIYUAN_URL/api/system/version" -H "$AUTH" | grep -q 200; then
    echo "ERROR: Siyuan not reachable at $SIYUAN_URL"
    exit 2
fi

# --- Last Git commit timestamp + buffer (YYYYMMDDHHmmss, matching Siyuan format) ---
# Buffer: 2 minutes after Git commit. The sync-to-siyuan.sh runs right after git push,
# so docs it updates get timestamps a few seconds after the Git commit. The buffer
# ensures we don't flag sync-updated docs as human edits.
LAST_GIT_TS_RAW=$(git -C "$REPO_DIR" log -1 --format=%cd --date=format:'%Y%m%d%H%M%S' 2>/dev/null || echo "")
if [[ -z "$LAST_GIT_TS_RAW" ]]; then
    echo "ERROR: Could not read last Git commit timestamp from $REPO_DIR"
    exit 2
fi

# Add 2-minute buffer
CUTOFF_TS=$(python3 -c "
from datetime import datetime, timedelta
ts = datetime.strptime('$LAST_GIT_TS_RAW', '%Y%m%d%H%M%S')
buffered = ts + timedelta(minutes=2)
print(buffered.strftime('%Y%m%d%H%M%S'))
")

echo "=== Siyuan Edit Check ==="
echo "Last Git commit: $LAST_GIT_TS_RAW ($(git -C "$REPO_DIR" log -1 --format='%s' 2>/dev/null))"
echo "Cutoff (commit + 2min buffer): $CUTOFF_TS"
echo ""

FOUND_EDITS=false

# --- Step 1: Documents modified in Siyuan AFTER last Git commit ---
# With diff-before-write sync, only docs with real content changes get new timestamps.
# So anything newer than the last Git commit = human edit.
MODIFIED_DOCS=$(siyuan_api "query/sql" "{\"stmt\":\"SELECT id, hpath, updated FROM blocks WHERE type='d' AND box='$NOTEBOOK_ID' AND updated > '$CUTOFF_TS' ORDER BY updated DESC\"}" | \
    python3 -c "
import json, sys
data = json.load(sys.stdin).get('data', [])
for row in data:
    # Skip pure folder docs (hpath has no content — just structural containers)
    # Folder docs have hpaths like /Projects or /Infrastructure/skills
    # Real docs have titles derived from content
    print(f\"{row['id']}\t{row['hpath']}\t{row['updated']}\")
" 2>/dev/null || echo "")

if [[ -n "$MODIFIED_DOCS" ]]; then
    # Filter: fetch each doc and skip empty ones (Siyuan folder containers)
    REAL_EDITS=""
    while IFS=$'\t' read -r doc_id hpath updated; do
        [[ -z "$doc_id" ]] && continue

        CONTENT=$(siyuan_api "export/exportMdContent" "{\"id\":\"$doc_id\"}" | \
            python3 -c "import json,sys; print(json.load(sys.stdin).get('data',{}).get('content','').strip())" 2>/dev/null)

        # Skip empty docs (folder containers in Siyuan)
        [[ -z "$CONTENT" ]] && continue

        REAL_EDITS+="found"
        FOUND_EDITS=true

        echo "📝 Modified: $hpath"
        echo "   Updated: $updated"

        PREVIEW=$(echo "$CONTENT" | head -20)
        LINE_COUNT=$(echo "$CONTENT" | wc -l)
        echo "   --- content preview ---"
        echo "$PREVIEW" | sed 's/^/   /'
        if [[ "$LINE_COUNT" -gt 20 ]]; then
            echo "   ... ($LINE_COUNT lines total)"
        fi
        echo ""
    done <<< "$MODIFIED_DOCS"
fi

# --- Step 2: Documents in Siyuan that don't exist in Git ---
# These were created by a human directly in Siyuan.
ALL_SIYUAN_DOCS=$(siyuan_api "query/sql" "{\"stmt\":\"SELECT id, hpath, updated FROM blocks WHERE type='d' AND box='$NOTEBOOK_ID' ORDER BY hpath\"}" | \
    python3 -c "
import json, sys
data = json.load(sys.stdin).get('data', [])
for row in data:
    print(f\"{row['id']}\t{row['hpath']}\t{row['updated']}\")
" 2>/dev/null || echo "")

# Build Git hpaths for comparison (same logic as sync-to-siyuan.sh)
GIT_HPATHS=$(find "$REPO_DIR" -name "*.md" \
    -not -path "*/.git/*" \
    -not -name "CLAUDE.md" \
    -not -name "AGENTS.md" \
    | sort \
    | while read -r abs_path; do
        rel_path="${abs_path#$REPO_DIR/}"
        dir_part=$(dirname "$rel_path")
        h1=$(grep -m1 '^# ' "$abs_path" 2>/dev/null | sed 's/^# //' | tr -d '\r' || true)
        if [[ -n "$h1" ]]; then
            title="$h1"
        else
            title=$(basename "$abs_path" .md | sed 's/[-_]/ /g' | python3 -c "import sys; print(sys.stdin.read().strip().title())")
        fi
        if [[ "$dir_part" == "." ]]; then
            echo "/$title"
        else
            echo "/$dir_part/$title"
        fi
    done)

while IFS=$'\t' read -r doc_id hpath updated; do
    [[ -z "$hpath" ]] && continue

    # Skip if this hpath exists in Git
    echo "$GIT_HPATHS" | grep -qxF "$hpath" && continue

    # Fetch content — skip empty folder containers
    CONTENT=$(siyuan_api "export/exportMdContent" "{\"id\":\"$doc_id\"}" | \
        python3 -c "import json,sys; print(json.load(sys.stdin).get('data',{}).get('content','').strip())" 2>/dev/null)
    [[ -z "$CONTENT" ]] && continue

    FOUND_EDITS=true

    echo "🆕 New (Siyuan-only): $hpath"
    echo "   Updated: $updated"

    PREVIEW=$(echo "$CONTENT" | head -20)
    LINE_COUNT=$(echo "$CONTENT" | wc -l)
    echo "   --- content preview ---"
    echo "$PREVIEW" | sed 's/^/   /'
    if [[ "$LINE_COUNT" -gt 20 ]]; then
        echo "   ... ($LINE_COUNT lines total)"
    fi
    echo ""
done <<< "$ALL_SIYUAN_DOCS"

# --- Result ---
if [[ "$FOUND_EDITS" == true ]]; then
    echo "=== Human edits detected — review before starting work ==="
    exit 0
else
    echo "✅ No human edits in Siyuan since last Git sync."
    exit 1
fi
