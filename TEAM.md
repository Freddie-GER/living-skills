# Living Skills — Team Configuration

> This file is the single source of truth for all AI tools in this repository.
> `CLAUDE.md` (Claude Code) and `AGENTS.md` (Codex) are symlinks pointing here.
> Cursor reads `.cursor/rules/living-skills.mdc` separately.
> Edit only this file — all tools pick up the changes automatically.

## Who I am

Set your instance name here. It appears in every commit message:
```
<Your-Instance-Name>: <skill-name> — session [YYYY-MM-DD]
```

Examples: `Claude-Mac`, `Claude-Server`, `Claude-Laptop`

## Repository layout

```
Infrastructure/skills/     ← Domain Skills for systems and tools
Projects/<name>/skills/    ← Domain Skills for specific projects
Team Memory/skills/        ← Behavioral Skills (methodologies, workflows)
Team Memory/<instance>/    ← Your memory: status.md, config.md
Team Memory/shared/        ← Human-contributed context
```

## Session Start

At the beginning of every session involving a Living Skill:

1. `git pull` — get the latest learnings from all instances
2. Read the relevant `Skill.md` — understand the approach
3. Read the relevant `living-checklist.md` — load accumulated knowledge
4. Apply checklist entries to the current task

## Session End

After completing a task that used a Living Skill:

1. Write new learnings to `living-checklist.md`:
   ```
   ### [YYYY-MM-DD] — [task context]
   **Learning:** what was discovered or what failed
   **Why it matters:** context and consequences
   **Rule:** a concrete guideline for next time
   ```
2. Commit and push:
   ```bash
   git add <skill-path>/living-checklist.md
   git commit -m "<Your-Instance-Name>: <skill-name> — session [YYYY-MM-DD]"
   git push
   ```

## Write boundaries

Write only to your own `Team Memory/<instance>/` folder.
Other instances' folders are read-only — even if a task seems to call for it.
Each instance documents its own work so others can read it.

## Available skills

Update this list as you add skills:

| Path | Use for |
|------|---------|
| `Team Memory/skills/` | Behavioral skills — browse for what fits |
| `Infrastructure/skills/` | Domain skills — systems and tools |

## First time setup?

See [`setup/onboarding-new-instance.md`](setup/onboarding-new-instance.md).
