# Onboarding a New Instance

How to add a new agent or AI model to an existing Living Skills pool.

---

## What "onboarding" means

A new instance needs three things:
1. Access to the shared Git repository
2. A way to read and write files
3. Instructions on when and how to use the skills

The skills themselves don't need to be modified. They are model-agnostic by design.

---

## Step 1: Access to the Repository

Follow [sync-setup.md](sync-setup.md) to give the new machine/environment
access to the shared Git remote.

```bash
git clone <remote-url> living-skills
cd living-skills
git log --oneline -5   # verify you see existing commits from other instances
```

---

## Step 2: Choose an Instance Name

Pick a short name that identifies this machine and agent in Git commits.
Examples: `Claude-Mac`, `Claude-Server`, `Codex-Laptop`, `LocalLLM-NAS`

The name ends up in commit messages like:
```
Claude-Mac: home-assistant — session [2026-04-10]
```

### How to set it — pick whichever fits your setup

**Option A: Put it in your agent's config file (recommended)**

For Claude Code, add this line to your `CLAUDE.md` (the project instructions file):
```
My instance name for Living Skills commits: Claude-Mac
```
Your agent will pick it up from there and use it in commit messages.

**Option B: Add it to your shell profile (persistent, technical)**

Open your shell profile in a text editor:
- On Mac/Linux with zsh: `~/.zshrc`
- On Mac/Linux with bash: `~/.bashrc`
- On Windows: use System Properties → Environment Variables

Add this line:
```bash
export LIVING_SKILLS_INSTANCE="Claude-Mac"
```

Then reload it: `source ~/.zshrc` (or restart your terminal).

**Option C: Just tell your agent at session start (simplest)**

At the start of every session, say:
> "Your instance name for commit messages is Claude-Mac."

No configuration needed. Works with any agent.

---

## Step 3: Instruct the Agent

The new instance needs to know the session rituals. Add this to its
system prompt, CLAUDE.md, or equivalent configuration file:

```
# Living Skills

Before starting any task covered by a skill, read:
  - skills/<skill-name>/Skill.md
  - skills/<skill-name>/living-checklist.md

After completing the task, write any new learnings to:
  - skills/<skill-name>/living-checklist.md

Entry format:
  ### [YYYY-MM-DD] — [Task context]
  **Learning:** What was discovered
  **Why it matters:** Context
  **Rule:** Actionable guideline for future sessions

Then commit:
  git add skills/<skill-name>/living-checklist.md
  git commit -m "<INSTANCE_NAME>: <skill-name> — session [YYYY-MM-DD]"
  git push
```

---

## Step 4: Run a First Session

Pick one existing skill and run a real task with it:

1. `git pull`
2. Read `skills/<skill-name>/Skill.md`
3. Read `skills/<skill-name>/living-checklist.md`
4. Complete the task
5. Write at least one entry to living-checklist.md (even if minimal)
6. Commit and push

Check the result:
```bash
git log --oneline -3
# Should show: "YourInstance: skill-name — session [date]"
```

---

## Step 5: Verify Cross-Instance Visibility

On another machine or instance:
```bash
git pull
cat skills/<skill-name>/living-checklist.md
```

The new instance's entry should be visible. The loop is closed.

---

## Notes on Different Model Families

Living Skills work with any model that can:
- Read files from disk
- Write files to disk
- Run basic shell commands (git)

**Claude Code:** Built-in filesystem and bash access. Works out of the box.

**OpenAI Codex / Cursor:** Filesystem access via editor integration.
  Ensure the agent can write to the repository directory.

**Local models (Ollama, LM Studio) via agent frameworks:**
  Requires an agent framework that provides file tools (e.g., Open WebUI with
  tool support, LangChain agents, or a custom wrapper). The model itself
  does not need special capabilities beyond text generation.

**Aider:** Can read/write files natively. Add the living-skills repo to
  its working directory.

---

## What Different Models Bring

Different model families tend to approach problems differently.
This is a feature, not a bug:

- One model may catch patterns another misses
- Different "cognitive styles" produce richer living-checklists over time
- The skill grows from multiple perspectives

Do not try to normalize entries across models. Diversity in the checklist
is the point.
