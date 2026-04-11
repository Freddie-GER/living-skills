# Agent Configuration — Living Skills

Your agent needs to know three things to use Living Skills correctly:

1. **Where** the skill repository lives on disk
2. **Who** it is (its instance name, for commit messages)
3. **What to do** at session start and end (the rituals)

This guide shows complete, copy-paste-ready configurations for the most common setups.
Replace everything in `<angle brackets>` with your actual values.

---

## Claude Code — CLAUDE.md

Claude Code reads a file called `CLAUDE.md` at the start of every session.
This is the right place to configure Living Skills.

**Where to put it:** In the root of your Living Skills repository, or in your
home directory (`~/.claude/CLAUDE.md`) to apply it globally.

```markdown
# Living Skills Configuration

## Who I am
My instance name for commit messages: <Your-Instance-Name>
Example: Claude-Mac, Claude-Server, Claude-Laptop

## Repository location
The Living Skills repository is at: <absolute path to the repo>
Example: /Users/yourname/living-skills

## Session Start (always do this first)
At the beginning of every session involving a Living Skill:
1. Run: git -C <path-to-repo> pull
2. Read the relevant Skill.md
3. Read the relevant living-checklist.md
4. Apply what you learned from the checklist to the current task

## Session End (always do this last)
After completing a task that used a Living Skill:
1. Write new learnings to living-checklist.md using this format:
   ### [today's date] — [brief task description]
   **Learning:** what was discovered or what failed
   **Why it matters:** context and consequences
   **Rule:** a concrete guideline for next time
2. Stage and commit:
   git -C <path-to-repo> add skills/<skill-name>/living-checklist.md
   git -C <path-to-repo> commit -m "<Your-Instance-Name>: <skill-name> — session [date]"
   git -C <path-to-repo> push

## Available skills
List the skills in your repository so I know what's available:
- skills/my-first-skill/ — [what it's for]
- skills/my-domain/ — [what it's for]
```

**Minimal version** (if you want to keep it short):

```markdown
# Living Skills

Instance name: <Your-Instance-Name>
Repository: <path-to-repo>

Before any task: git pull, read Skill.md and living-checklist.md for the relevant skill.
After any task: write learnings to living-checklist.md, commit and push.
```

---

## Cursor — .cursor/rules

Cursor reads rules files from `.cursor/rules/` in your project directory.
Create a file called `.cursor/rules/living-skills.mdc`:

```markdown
---
description: Living Skills session rituals and configuration
alwaysApply: true
---

# Living Skills

## Instance identity
Always identify yourself as: <Your-Instance-Name>
Use this name in all Git commit messages.

## Repository
The Living Skills repository is at: <absolute path>

## Available skills

| Path | Purpose |
|------|---------|
| `skills/<skill-a>/` | [what it's for] |
| `skills/<skill-b>/` | [what it's for] |

## Before starting any task covered by a skill
1. Run `git pull` in the repository directory
2. Read `skills/<relevant-skill>/Skill.md` — understand the approach
3. Read `skills/<relevant-skill>/living-checklist.md` — load accumulated learnings
4. Apply checklist entries to the current task

## After completing a task
Write new learnings to `skills/<relevant-skill>/living-checklist.md`:

### Format
### [YYYY-MM-DD] — [task context]
**Learning:** [what was discovered]
**Why it matters:** [context]
**Rule:** [actionable guideline for future sessions]

Then commit:
git add skills/<skill>/living-checklist.md
git commit -m "<Your-Instance-Name>: <skill> — session [date]"
git push
```

**Practical notes from production use:**

- **`alwaysApply: true`** loads the rules into every Cursor session. This works well
  when the repo is dedicated to Living Skills. If the repo also contains other projects,
  consider using a `description`-based trigger instead — but note that Cursor's matching
  can be unreliable, so `alwaysApply` is the safer choice.
- **Explicit skill table** is better than auto-discovery in Cursor. Unlike Claude Code,
  Cursor does not always explore the file tree proactively — listing skills explicitly
  ensures they are found.
- **Combine with an identity rule** if you have a separate `.mdc` for team/instance
  identity. Use a description like `"Living Skills session rituals — supplements identity-rule.mdc"`
  to signal that both rules work together.
- **Caveat:** Global Cursor rules (`~/.cursor/rules/`) apply to all repos, including
  private ones without team context. See [Known Gaps — Context-Dependent Tool Identity](../known-gaps.md#2026-04-11-context-dependent-tool-identity) for the open design problem.

---

## Generic System Prompt

If your agent accepts a system prompt (ChatGPT custom instructions, API system field,
Open WebUI system prompt, or similar), paste this in:

```
You have access to a Living Skills repository at <path or description of location>.

Your instance name is: <Your-Instance-Name>

BEFORE starting any task covered by a skill:
- Pull the latest version of the repository (git pull, or ask the user to confirm it's up to date)
- Read the Skill.md for the relevant skill
- Read the living-checklist.md for the relevant skill
- Apply the checklist learnings to how you approach the task

AFTER completing a task covered by a skill:
- Write any new learnings to living-checklist.md using this format:
  ### [date] — [task context]
  **Learning:** what was discovered or what failed
  **Why it matters:** context
  **Rule:** actionable guideline for next time
- Commit the changes: git commit -m "<Your-Instance-Name>: <skill-name> — session [date]"
- Push to the remote

The available skills are: <list them here>
```

---

## What "available skills" means

You don't have to list every skill manually. You can tell the agent to discover them:

```
The skills directory is at: <path>/skills/
Read the Skill.md files there to understand what skills are available
and when to use each one.
```

Or list them explicitly for faster sessions:

```
Available skills:
- skills/code-review/ — use when reviewing pull requests or any code changes
- skills/home-assistant/ — use for any smart home automation work
- skills/research/ — use for any research or analysis task
```

Explicit lists load faster. Discovery is more flexible. Pick what works for your setup.

---

## Multi-instance setup: two machines, one repository

If you run two agents on two different machines (e.g. a laptop and a server),
each machine needs its own CLAUDE.md (or equivalent) with its own instance name,
but both pointing to the same remote Git repository.

**Machine 1 — CLAUDE.md:**
```
Instance name: Claude-Laptop
Repository: /home/user/living-skills
Remote: git@github.com:your-org/living-skills.git
```

**Machine 2 — CLAUDE.md:**
```
Instance name: Claude-Server
Repository: /opt/living-skills
Remote: git@github.com:your-org/living-skills.git  ← same remote
```

Both agents pull before sessions and push after. Git handles the merge.
See [sync-setup.md](sync-setup.md) for the full sync configuration.

---

## Tested environments

| Environment | Config file | Status |
|-------------|-------------|--------|
| Claude Code | `CLAUDE.md` → symlink to `TEAM.md` | ✅ Tested, works in production |
| Codex (OpenAI) | `AGENTS.md` → symlink to `TEAM.md` | ✅ Configuration in place |
| Cursor | `.cursor/rules/*.mdc` | ✅ Tested, works in production |
| Aider | `.aider.conf.yml` or system prompt | 🔬 Untested |
| Open WebUI | System prompt field | 🔬 Untested |

**Note:** `CLAUDE.md` (Claude Code) and `AGENTS.md` (Codex) are both symlinks to `TEAM.md`.
This is the recommended pattern — maintain one file, all tools read the same source.

If you get it working in an environment not listed here, please
[contribute a configuration example](../CONTRIBUTING.md).
