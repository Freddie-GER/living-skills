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
       │  Infrastructure/skills/siyuan/scripts/sync-to-siyuan.sh
       │  (run manually after git push — part of session-end ritual)
       ▼
Siyuan Knowledge Base (human-readable view)
       │
       │  Human reads, annotates, adds notes
       ▼
  [gap: not yet flowing back to Git — see known-gaps.md]
```

Git is the source of truth. Siyuan is the reading interface.

**Important:** The sync script runs after every successful `git push` — not via a daemon,
not via a git hook. The agent is responsible. This ensures the sync always reflects
the complete, merged state of the repository.

---

## Setup — Interactive Onboarding

Work through these steps with the user when setting up Siyuan for a new instance:

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

---

### Step 2: Notebook Structure

Ask the user:
> "Do you want one notebook per domain (Infrastructure, Projects, Team Memory)
> or one shared notebook for everything?"

**Recommended:** One notebook named after your team or project.
Subdirectory structure mirrors the Git repo:
```
<NotebookName>/
  Infrastructure/
  Projects/
  Team Memory/
```

Note the Notebook ID — you will need it in the next step.
Find it via: Siyuan → Settings → About → Notebook ID, or from the URL when viewing the notebook.

---

### Step 3: Create the .env File

The sync script reads credentials from a `.env` file at the repo root.
This file is excluded from Git (listed in `.gitignore`) — each instance creates it locally.

Create `<repo-root>/.env`:
```bash
SIYUAN_URL="http://<host>:6806"
SIYUAN_TOKEN="<your-token>"
SIYUAN_NOTEBOOK_ID="<notebook-id>"
```

**Test the connection:**
```bash
curl -s http://<host>:6806/api/system/version \
  -H "Authorization: Token <your-token>"
# Should return: {"code":0,"data":{"ver":"..."}}
```

---

### Step 4: Run the First Sync

```bash
git push && bash Infrastructure/skills/siyuan/scripts/sync-to-siyuan.sh
```

Check the output — every `.md` file should show `UPDATE` or `CREATE`.
Then open Siyuan and verify the notebook structure matches your repo.

---

### Step 5: Add Sync to Session-End Ritual

Add this to your `TEAM.md` (or equivalent agent config):

```bash
# Session end — always:
git add <changed files>
git commit -m "<Instance>: <what> [YYYY-MM-DD]"
git push && bash Infrastructure/skills/siyuan/scripts/sync-to-siyuan.sh
```

The `&&` ensures Siyuan sync only runs after a successful push.
The script syncs ALL `.md` files — whoever pushes last writes the complete state to Siyuan.

---

### Step 6: MCP Access (optional, for agents)

MCP lets agents query Siyuan directly — useful for reading human annotations at session start.

**Install:** `siyuan-mcp` (check npm for current version)

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

- Always test the API connection before running the sync script
- Use the Notebook ID, not the display name — display names can change, IDs don't
- The sync script derives the Siyuan HPath from the first `# H1` heading in each file.
  If a heading changes, Siyuan creates a new document instead of updating the existing one.
- Run sync only after `git push` — never before. A failed push means another instance
  may have newer changes; syncing before rebasing would push a stale state to Siyuan.

---

## Open TODOs

- [ ] Reverse sync: human edits in Siyuan → Git commit (see known-gaps.md)
- [ ] Notion equivalent of this skill
- [ ] Obsidian equivalent of this skill

---

## Session End

After each session: write new learnings, configuration patterns, API quirks,
or sync edge cases to `living-checklist.md`.
Commit, push, and sync to Siyuan.
