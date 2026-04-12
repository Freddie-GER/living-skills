# Team Charter Setup

How to set up the host-level team charter for a real Living Skills deployment.

This is a different problem from onboarding one new instance.
Onboarding explains how to add one participant to an existing setup.
The team charter defines how the shared team context itself works.

---

## What the team charter is

Living Skills gives you the knowledge architecture:
- `Skill.md`
- `living-checklist.md`
- `revisionslog.md`
- `Team Memory/`

For a real team, you also need one host-level document that explains how this shared
environment operates in practice. In our production setup, that file is called `TEAM.md`.

This file is the bridge between:
- the general Living Skills framework
- the concrete working rules of one real team

It is host-specific by design. Do not try to make it universally reusable.

---

## When you need it

You should create a `TEAM.md` if any of the following is true:
- more than one persistent tool instance uses the same repository
- the same human works through multiple tool identities
- multiple humans share one Living Skills environment
- the repository has local paths, credentials, scripts, or rituals that are specific to this setup

For a single-user, single-tool setup, the charter can be minimal.
For anything more complex, it becomes operationally necessary.

---

## What belongs in `TEAM.md`

At minimum, the team charter should define:

### 1. Team identities

List the active participants in the shared context.
These are not abstract "agents" in an orchestration system. They are the concrete working
identities in this environment, for example:
- `Claude Mac`
- `Codex Mac`
- `Cursor Mac`
- `Claude Server`

### 2. Write boundaries

Define clearly:
- which directory each identity may write to
- which directories are read-only
- which areas are collaborative

Without this, multi-participant memory becomes ambiguous very quickly.

### 3. Session start and end rituals

Define the actual commands and expectations for this environment:
- how to pull
- what to read first
- how to commit
- whether sync scripts are required after push

These are environment-specific and do not belong in the generic framework spec.

### 4. Tool bindings

Explain how each tool reads the charter:
- `CLAUDE.md` → symlink or reference to `TEAM.md`
- `AGENTS.md` → symlink or reference to `TEAM.md`
- Cursor rules → replicate the relevant team instructions in `.cursor/rules/`

The point is not identical tooling. The point is a single shared source of truth.

### 5. Local environment notes

Document anything that is specific to this host setup:
- absolute paths
- credentials location
- machine names
- service endpoints
- scripts that are part of the normal workflow

Keep secrets out of Git. Describe where they live, not their raw values.

---

## Recommended structure

```markdown
# Team Name — Shared Context

## Team
| Identity | Tool | Writes in |
|----------|------|-----------|
| ... | ... | ... |

## Write Rule
[Who writes where, what is read-only, what is collaborative]

## Repository Layout
[Short explanation of top-level folders]

## Session Start
[Exact commands and required reads]

## Session End
[Exact commands and follow-up actions]

## Living Skills
[Where behavioral and domain skills live, activation protocol if relevant]

## Language / Conventions
[Documentation language, commit style, naming rules]
```

See [`templates/TEAM.md`](../templates/TEAM.md) for a copyable starting point.

---

## Relationship to instance onboarding

These are two different layers:

- [`onboarding-new-instance.md`](onboarding-new-instance.md)
  Adds one new participant to an already defined shared environment
- `TEAM.md`
  Defines the shared environment itself

Do the charter first. Then onboard instances into it.

---

## Design intent

This file is deliberately explicit and human-readable.
It is not a hidden orchestration layer.

We do **not** want a system that silently routes work, assigns ownership, or hides
operational assumptions in code. The point of the charter is the opposite:
- make team rules visible
- make disagreements discussable
- make ownership auditable
- keep the human in the loop

In short: the framework provides the memory architecture; the team charter provides
the social and operational contract.
