# Quickstart — Living Skills

Get a Living Skill working in under 10 minutes.

---

## Prerequisites

- An AI agent with filesystem read/write access (Claude Code, Cursor, Codex, etc.)
- Git installed and configured
- A Git remote (GitHub, GitLab, Gitea, or self-hosted)

---

## Step 1: Clone or fork this repository

```bash
git clone https://github.com/your-org/living-skills.git
cd living-skills
```

Or start fresh:
```bash
mkdir my-skills && cd my-skills
git init
git remote add origin <your-remote-url>
```

---

## Step 2: Create your first skill

Pick a template based on what you want:

**Behavioral Skill** — for workflows, methodologies, how your agent approaches a problem:
```bash
cp -r templates/behavioral-skill/ skills/my-first-skill/
```

**Domain Skill** — for a specific system, codebase, or recurring technical domain:
```bash
cp -r templates/domain-skill/ skills/my-domain/
```

---

## Step 3: Fill in the template

Open `skills/my-skill/Skill.md` and replace all placeholders.
The most important fields:

- `name` — short, memorable
- `description` — this is how your agent decides when to use the skill; be specific
- `## Session Start` — what files to read, what context to load
- `## Session End` — what to write back to living-checklist.md

Open `skills/my-skill/living-checklist.md` and add at least one seed entry.
Start with something you already know — a pitfall, a pattern, a lesson learned.
Do not leave it empty.

---

## Step 4: Tell your agent about the skill

At the start of a session, instruct your agent:

> "Before we begin: read `skills/my-skill/Skill.md` and
> `skills/my-skill/living-checklist.md`."

At the end of a session:

> "Write any new learnings to `skills/my-skill/living-checklist.md`
> and commit."

That's it. The skill will grow from here.

---

## Step 5: Commit and push

```bash
git add skills/my-skill/
git commit -m "MyInstance: my-skill — initial skill [$(date +%Y-%m-%d)]"
git push
```

---

## Next Steps

- [agent-configuration.md](agent-configuration.md) — complete CLAUDE.md / Cursor / system prompt examples
- [sync-setup.md](sync-setup.md) — connect multiple instances to the same skill pool
- [onboarding-new-instance.md](onboarding-new-instance.md) — add a second agent or a different model
- [framework.md](../framework.md) — full specification for advanced usage
