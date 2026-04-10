# Living Skills

**A framework for AI skills that learn across sessions.**

Living Skills extends the idea of static AI skill definitions with a persistent learning layer.
Instead of loading the same instructions every session, a Living Skill remembers what worked,
what failed, and improves its own approach over time — across sessions, across instances,
and across different AI models.

---

## The Problem with Static Skills

Current skill systems (Anthropic Plugins, Claude.ai Skills, custom system prompts) share one limitation:
they are stateless. Every session starts from zero. Lessons learned are lost. The same mistakes repeat.

A static skill is a document. A Living Skill is a document that grows.

---

## What Living Skills Add

```
Static Skill:   Skill.md → loaded into context → session ends → forgotten

Living Skill:   Skill.md          (what to do — stable core)
                living-checklist.md   (what we learned — grows each session)
                revisionslog.md       (what changed and why)

                Session N:   read living-checklist → act → write new learnings back
                Session N+1: starts smarter than N
```

The living-checklist is the memory. The session-end ritual is the learning mechanism.

---

## Intellectual Foundation

Living Skills is a synthesis of existing ideas, not a new invention:

| Concept | Source | How it appears here |
|---------|--------|---------------------|
| Skill format | Anthropic Claude Plugins | `Skill.md` with YAML frontmatter |
| Filesystem as memory | Karpathy / Autoresearch | Git as source of truth, Markdown files |
| Iterative self-improvement | Ralph Loop | Intra-session iteration with stop criteria |
| Never stop at first result | Karpathy Autoresearch | Explicit max iterations + stop reason |
| Persistent knowledge base | LLM Wiki concept | living-checklist grows like a wiki |
| Multi-instance collaboration | This project | Any agent/model writes to shared Git repo |

Credit where it's due: Andrej Karpathy's Autoresearch project and LLM Wiki concept
are direct inspirations. The Ralph Loop is a related iterative evaluation pattern.
Living Skills applies these ideas specifically to the domain of **agent behavior and
procedural knowledge**, not just information retrieval.

---

## Core Architecture

### Skill Structure

```
skills/<skill-name>/
├── Skill.md              # What to do (stable, curated by humans + AI)
├── living-checklist.md   # What we learned (grows after every session)
└── revisionslog.md       # What changed in Skill.md and why
```

### Two Skill Types

**Type A — Behavioral Skill**
Defines *how* an AI agent approaches a class of problems.
Example: Adversarial review methodology, research protocols, code review style.

**Type B — Domain Skill**
Stores *what works* in a specific technical or project domain.
Example: Home Assistant automations, Kubernetes cluster management, a specific codebase.

Both types use the same file structure. The difference is in what Skill.md contains.

### Session Rituals

Every Living Skill session follows two rituals:

**Session Start:**
1. Read `Skill.md` — understand the approach
2. Read `living-checklist.md` — load accumulated knowledge
3. Apply checklist entries to the current task

**Session End:**
1. Identify new learnings: patterns, failures, unexpected behaviors
2. Write them to `living-checklist.md` in standardized format
3. Update `revisionslog.md` if `Skill.md` was changed
4. Commit to Git

### Living Checklist Entry Format

```markdown
### [YYYY-MM-DD] — [Task context]
**Learning:** What was discovered
**Why it matters:** Context and consequences
**Rule:** Concrete actionable guideline for future sessions
```

---

## The Ralph Loop

Not every skill needs a Ralph Loop. Apply it when the first result is likely insufficient:
complex analysis, debugging, research tasks, anything where "good enough" isn't good enough.

```
Iteration 1: Initial attempt
→ Self-evaluation: Which criteria are unmet? Where are gaps?

Iteration 2: Targeted follow-up
→ Self-evaluation: Criteria check

Iteration N (max): Final pass
→ Document: Why stopping here? What remains open?
```

**Stop criteria must be defined before starting**, not after. A skill that uses Ralph Loop
should specify its stop criteria in `Skill.md`.

Reference implementation: `examples/advocatus-diaboli/` — full iterative adversarial review
with explicit stop criteria and living-checklist integration.

---

## Multi-Instance Sync

The architecture is designed to let any agent with filesystem access share a skill pool:

```
Instance A (Claude Code, Machine 1)  ─┐
Instance B (Claude Code, Machine 2)  ─┤─→ Git repository ←─ shared source of truth
Instance C (Cursor, Machine 3)       ─┤
Instance D (local LLM, Machine 4)   ─┘
```

Each instance reads the same `living-checklist.md` before acting.
Each instance writes its learnings back after acting.
Different models bring different cognitive approaches — the checklist becomes richer
than any single instance could make it.

Git handles conflict resolution. Commit messages identify which instance contributed what.

**Convention for commit messages:**
```
<Instance-Name>: <Skill-Name> — session [YYYY-MM-DD]
```

**Honest status:** This is tested and working with Claude Code across two machines.
The multi-model scenario (different model families sharing one skill pool) is
architecturally straightforward but not yet tested in practice. If you try it,
[we'd love to hear how it goes](CONTRIBUTING.md).

### Optional: Human-Readable Layer

The Git repository can be synced to any Markdown-capable knowledge base
(Obsidian, Notion, Siyuan, Logseq) to give humans a readable view into
what the agents are learning. This layer is read-only for humans — Git remains
the authoritative source.

---

## Getting Started

### 1. Create a Behavioral Skill

```bash
mkdir -p skills/my-skill
```

Use the template in `templates/behavioral-skill/` as starting point.
Fill in `Skill.md` with your approach, leave `living-checklist.md` mostly empty
(add one or two seed entries from what you already know).

### 2. Create a Domain Skill

```bash
mkdir -p skills/my-domain
```

Use `templates/domain-skill/` as starting point.
`Skill.md` is a reference document (system info, procedures, access details).
`living-checklist.md` starts with known pitfalls and proven solutions.

### 3. Use a Skill

At session start, instruct your agent:
> "Read `skills/my-skill/Skill.md` and `skills/my-skill/living-checklist.md` before proceeding."

At session end:
> "Write any new learnings to `skills/my-skill/living-checklist.md` and commit."

### 4. Create a Skill with skill-creator

Use the `skill-creator` skill (see `skills/skill-creator/`) to build new skills
interactively. It guides through intent capture, structure, and session ritual design.

---

## Reference Implementations

| Skill | Type | What it demonstrates |
|-------|------|----------------------|
| `examples/advocatus-diaboli/` | Behavioral | Ralph Loop, stop criteria, full iteration pattern |
| `examples/home-assistant/` | Domain | Known pitfalls, Bugfix patterns, device reference |
| `skills/skill-creator/` | Behavioral | Creating new Living Skills |

---

## Repository Layout

```
living-skills/
├── README.md                         # This file
├── CONTRIBUTING.md                   # How to contribute
├── framework.md                      # Full specification
├── setup/
│   ├── quickstart.md                 # Get started in 10 minutes
│   ├── agent-configuration.md        # CLAUDE.md, Cursor, system prompt examples
│   ├── sync-setup.md                 # GitHub / Gitea / local network sync
│   └── onboarding-new-instance.md    # Add a second agent or different model
├── templates/
│   ├── behavioral-skill/             # Starter template: Type A
│   └── domain-skill/                 # Starter template: Type B
└── examples/
    ├── advocatus-diaboli/             # Reference: Behavioral Skill with Ralph Loop
    └── home-assistant/               # Reference: Domain Skill
```

---

## Status

**Working in production:** Two Claude Code instances on separate machines,
sharing a Git repository, writing to the same living-checklists across sessions.

**Tested environment:** Claude Code only.

**Untested but designed for:** Cursor, Aider, any agent with filesystem + Git access.
The framework is just Markdown and Git — if your agent can read files and run shell
commands, it should work. If you try it, [tell us how it went](CONTRIBUTING.md).

**Not yet tested:** True multi-model sync (e.g. Claude + Codex sharing one skill pool).
Architecturally it should work. We'd love a real-world report.
