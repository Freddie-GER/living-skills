# Living Skills

Persistent knowledge for human–AI problem solving.

LLMs forget. Built-in memory is opaque, leaky, and tool-bound. Teams lose context, repeat mistakes, and cannot reliably share what has already been learned.

Living Skills moves knowledge out of model memory into a shared, versioned, and inspectable system:
- Methods improve over time (how to work)
- Domain knowledge accumulates through use (what actually works)
- Humans drive, AI assists, the system learns automatically

Every session starts with what your team already knows — across tools, models, and time.

---

## Overview

Built-in memory systems (Claude's memory, ChatGPT's memory) are unstructured, opaque, and effectively vendor-locked. When you switch tools, you start over. Old information contaminates current work, and it is difficult to inspect, correct, or selectively reuse.

When a colleague needs to understand what the AI already knows, they usually cannot.

This framework replaces that with three components that work together:
- **Living Skills** — persistent, evolving knowledge that combines structured methods with accumulated experience
- **Team Memory** — structured project knowledge: state, decisions, assumptions, and domain context
- **Structure + Human Layer** — plain Markdown in Git, readable, writable, versioned, and optionally synced to tools like Siyuan, Obsidian, or Notion

It does not matter whether you are:
- one person using one tool
- one person using multiple tools (Claude Code, Codex, Cursor)
- or a team working across machines and environments

The framework remains the same.

---

## Problem Definition

Early LLM workflows were effectively stateless. Every session started from zero. Lessons were lost, mistakes repeated, and project context had to be rebuilt each time. Methodological learning did not accumulate in a durable way.

Built-in memory improves this, but does not solve the problem for real work:

- **Unstructured and opaque** — Memory is implicit and model-interpreted. It cannot be reliably inspected, audited, or corrected.
- **Leaky and unscoped** — Preferences, past interactions, and project knowledge mix. Models apply patterns outside their intended context.
- **No explicit methodology control** — The model guesses how to approach a task instead of following a defined method.
- **No shared team memory** — Knowledge is tied to a user or session. Teams lack a consistent, inspectable project state.
- **No portability** — Switching tools breaks continuity. Knowledge remains locked inside specific systems.
- **Context rot** — Long sessions degrade. Context windows truncate. You must choose between continuity and clarity.

What is missing is not more memory, but an explicit external layer for project state, decisions, learnings, and methodology.

---

## What This Framework Adds

### Team Memory

Team Memory gives every AI instance a structured home for project knowledge:

```
Team Memory/
  <instance>/        ← one folder per agent, created during onboarding
    status.md        ← current work, open items, recent decisions
    config.md        ← instance identity, paths, credentials
  shared/            ← human-contributed knowledge: user stories, stakeholder needs,
                        workshop results, decisions from meetings
  skills/            ← behavioral skills shared across all instances
```

Humans write here too. A product manager adds user story results after a workshop.
A team lead documents constraints or decisions.

AI instances read this at session start — structured and explicit, without relying on hidden or implicit memory.

### Living Skills

Living Skills provide persistent, evolving knowledge:

```
Static Skill:   Skill.md → loaded into context → session ends → forgotten

Living Skill:   Skill.md              (stable core — what to do)
                living-checklist.md   (learning layer — what we discovered)
                revisionslog.md       (what changed and why)

                Session N:   read checklist → act → write learnings back
                Session N+1: starts smarter than N
```

A debugging pattern found in one project carries into the next.
A fix discovered by Codex is available to Claude Code the next session.

Learning is not a separate task. It is captured as part of doing the work.

### Human Layer

Everything is inspectable and correctable:

```
Git repository  ←→  optional sync  ←→  Siyuan / Obsidian / Notion
(authoritative)                         (human-readable view)
```

Wrong entry in the checklist? Fix it directly.
Switching tools? Add a new instance — knowledge is already there.

---

## Two Knowledge Layers

This framework separates two fundamentally different types of knowledge:

### Method Knowledge (Behavioral Skills)

How to approach a problem.

Examples: business analysis, debugging, research workflows, code review.

These are transferable across domains, structurally stable, and improved over time.

### Domain Knowledge (Domain Skills)

What works in a specific system.

Examples: Home Assistant setup, a codebase, Kubernetes cluster, internal company processes.

These are context-specific, built through experience, and critical for real-world success.

### Why This Matters

Most systems mix these two. This framework separates them:
- Methods can be reused without contamination
- Domain knowledge accumulates without polluting general logic
- Strong methods can be applied in new domains
- Strong domains help refine methods

Method skills tell you how to think. Domain skills tell you what actually works.

---

## Scale Doesn't Matter

Living Skills is scale-neutral:

```
One tool:        Claude Code ─────────────→ Git repo
Multiple tools:  Claude Code ─┐
                 Codex        ─┤──────────→ Git repo
                 Cursor       ─┘
Team:            Alice        ─┐
                 Bob          ─┤──────────→ Git repo
                 Carlos       ─┘
```

Each instance reads before acting, writes after acting, and contributes to shared knowledge.

Different tools bring different strengths. The system improves through diversity.

No vendor lock-in. No knowledge loss.

---

## Intellectual Foundation

Living Skills is a synthesis and extension of existing ideas:

| Concept | Source / Origin | How it appears here | Note |
|---------|----------------|---------------------|------|
| Skill format | Anthropic Skills | Skill.md structured definitions | Direct inspiration |
| External knowledge in files | Karpathy LLM Wiki | Markdown-based knowledge | Direct inspiration |
| Iterative improvement | Karpathy Autoresearch | Learning through execution | High-level influence |
| Iteration loop + stopping | Ralph Loop | Explicit iteration with stop criteria | Correct attribution |
| Learning layer | Autoresearch + this project | living-checklist.md | Extended + structured |
| Core vs learning separation | Anthropic + Autoresearch (synthesis) | Skill vs checklist | Key contribution |
| Multi-instance via Git | Extension of LLM Wiki (this project) | Git coordination layer | Core extension |
| Versioned knowledge | Software engineering practice | Git history, diffs, rollback | Borrowed discipline |

---

## Core Architecture

### Repository Structure

```
Infrastructure/           ← domain skills for systems and tools
  skills/
    <skill-name>/
      Skill.md
      living-checklist.md
      revisionslog.md
Projects/                 ← domain skills for ongoing projects
  <project-name>/
    skills/
      <skill-name>/
Team Memory/              ← instance memory and behavioral skills
  <instance-name>/        ← created by each agent during onboarding
    status.md
    config.md
  shared/                 ← human-contributed context
  skills/                 ← behavioral skills (methodologies, workflows)
    <skill-name>/
```

### Two Skill Types

**Type A — Behavioral Skill** → lives in `Team Memory/skills/`
Defines how to approach problems — transferable across domains.

**Type B — Domain Skill** → lives in `Infrastructure/skills/` or `Projects/<name>/skills/`
Defines what works in a specific system — built through experience.

### Session Ritual

**Start:**
1. Read `Skill.md`
2. Read `living-checklist.md`
3. Apply

**End:**
1. Extract learnings
2. Write checklist
3. Update revisions
4. Commit

### Checklist Entry Format

```markdown
### [YYYY-MM-DD] — [Task context]
**Learning:** What was discovered
**Why it matters:** Context
**Rule:** Reusable guideline
```

### Ralph Loop

Used for complex tasks requiring iteration:

```
Iteration → Evaluate → Refine → Repeat
```

Stop criteria must be defined upfront.

### Multi-Instance Sync

Any agent with file access can participate. Git handles versioning, merging, and attribution.

---

## Status

**Tested in production:** Claude Code (multi-machine), Cursor.

**Tool configuration:**
- `TEAM.md` — single source of truth for all tools
- `CLAUDE.md` — symlink to `TEAM.md`, read by Claude Code
- `AGENTS.md` — symlink to `TEAM.md`, read by Codex
- `.cursor/rules/` — Cursor rules (separate format, same content)

One file to maintain. Every tool picks it up automatically.

**Untested but designed for:** Aider, Open WebUI, local models, any agent with filesystem + Git access.

---

## Getting Started

See [`setup/quickstart.md`](setup/quickstart.md) to get started in 10 minutes.

Reference implementations: [`examples/advocatus-diaboli/`](examples/advocatus-diaboli/) and [`examples/home-assistant/`](examples/home-assistant/).

---

> This framework turns problem-solving into a system that remembers how it got better — without relying on model memory.
