---
name: "Siyuan Knowledge Base"
description: "Use for ANY Siyuan setup, configuration, or sync work — connecting Siyuan to a Living Skills repo, MCP setup, API access, notebook structure, Git sync. Trigger: 'Siyuan', 'knowledge base', 'LLM wiki', 'sync to knowledge base'."
type: "domain"
---

# Siyuan Knowledge Base — Living Skill

Siyuan is an open-source, self-hostable knowledge base that serves as the human-readable
layer in a Living Skills setup. Agents write to Git; Siyuan mirrors the content for
human navigation, search, and annotation.

**Session Start:** Read `living-checklist.md` first.

---

## What Siyuan Does in This Framework

```
Git repository (authoritative)
       │
       │  sync-to-siyuan.sh (post-merge hook or manual)
       ▼
Siyuan Knowledge Base (human-readable view)
       │
       │  Human reads, annotates, adds notes
       ▼
  [gap: not yet flowing back to Git — see known-gaps.md]
```

Git is the source of truth. Siyuan is the reading interface.

---

## Setup — Interactive Onboarding

When setting up Siyuan for a new instance, work through these questions with the user:

### Step 1: Deployment

Ask the user:
> "Are you running Siyuan yourself, or using a hosted version?"

**Self-hosted (recommended for full control):**
- Docker: `docker run -d -p 6806:6806 -v /path/to/workspace:/siyuan/workspace b3log/siyuan`
- Default URL: `http://localhost:6806`
- Set an access token in Settings → About → API Token

**Hosted / cloud:**
- Note the URL provided by the hosting service
- Retrieve API token from account settings

Record in your `Team Memory/<instance>/config.md`:
```
SIYUAN_URL=http://<host>:6806
SIYUAN_TOKEN=<your-token>
```

---

### Step 2: Notebook Structure

Ask the user:
> "Do you want one notebook per domain (Infrastructure, Projects, Team Memory)
> or one shared notebook for everything?"

**Recommended:** One notebook called `Homelab` or your team name.
Subdirectory structure mirrors the Git repo:
```
Homelab/
  Infrastructure/
  Projects/
  Team Memory/
```

Note the Notebook ID from Siyuan's API or URL — you'll need it for the sync script.

---

### Step 3: Git → Siyuan Sync

The sync script (`sync-to-siyuan.sh` in the repo root) pushes all `.md` files to Siyuan
via its HTTP API. It runs automatically as a `post-merge` hook after `git pull`.

Configure environment variables:
```bash
export SIYUAN_URL="http://<host>:6806"
export SIYUAN_TOKEN="<your-token>"
```

Or store them in a `.env` file (excluded from Git via `.gitignore`).

**Test the connection:**
```bash
curl -s http://<host>:6806/api/system/version \
  -H "Authorization: Token <your-token>"
# Should return: {"code":0,"data":{"ver":"..."}}
```

**Run sync manually:**
```bash
bash sync-to-siyuan.sh
```

---

### Step 4: MCP Access (for agents)

MCP (Model Context Protocol) lets agents query Siyuan directly during sessions —
useful for the "inbox" pattern where humans leave notes for agents.

**Install:** `siyuan-mcp` (search npm registry for current package)

**Claude Code config** (`~/.claude.json`):
```json
{
  "mcpServers": {
    "siyuan": {
      "command": "npx",
      "args": ["-y", "siyuan-mcp"],
      "env": {
        "SIYUAN_URL": "http://<host>:6806",
        "SIYUAN_TOKEN": "<your-token>"
      }
    }
  }
}
```

Restart Claude Code for MCP tools to activate.

---

## Proven Approaches

- Always test the API connection before setting up the sync hook
- Use the notebook ID from the API, not the display name — display names can change
- The sync script is append-safe: it updates existing documents by replacing content,
  never creates duplicates as long as the HPath (hierarchical path) stays stable
- If a document disappears from Siyuan after sync: check that the `.md` file's
  first `# H1` heading hasn't changed — the HPath is derived from it

---

## Open TODOs

- [ ] Reverse sync: human edits in Siyuan → Git commit (see known-gaps.md)
- [ ] Notion equivalent of this skill
- [ ] Obsidian equivalent of this skill
- [ ] [Add your own TODOs here]

---

## Session End

After each session: write new learnings, configuration patterns, API quirks,
or sync edge cases to `living-checklist.md`.
