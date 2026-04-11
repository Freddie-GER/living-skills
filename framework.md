# Living Skills — Framework Specification

**Version:** 0.2
**Status:** Draft

---

## 1. File Structure (Required)

Every Living Skill is a directory containing exactly these three files:

```
<skill-name>/
├── Skill.md              # REQUIRED
├── living-checklist.md   # REQUIRED
├── revisionslog.md       # REQUIRED
└── scripts/              # OPTIONAL — executable code the agent can call
    ├── setup.sh
    ├── check-status.py
    └── ...
```

Additional files are allowed, but the three core files are not optional.
A directory missing any of them is not a Living Skill.

---

## 2. Skill.md — Specification

### Frontmatter (Required)

```yaml
---
name: "<Human-readable name, max 64 characters>"
description: "<What the skill does AND when to trigger it — specific, max 200 characters>"
type: "behavioral | domain"
---
```

**On description:** Write "pushy" — AI models tend to undertrigger skills.
Instead of: "Helps with debugging automations"
Write: "Use for ANY Home Assistant work — debugging, new automations, entities, updates"

### Required Body Sections

**For Behavioral Skills (Type A):**
- `## Session Start` — what to read, what to load
- `## Process` — step-by-step approach
- `## Stop Criteria` — when is the session successfully complete?
- `## Session End` — what to write back

**For Domain Skills (Type B):**
- `## System Reference` — access details, paths, configuration
- `## Proven Approaches` — what reliably works
- `## Session Start` — read living-checklist before working
- `## Session End` — write learnings back

### Length

Target: under 300 lines. Under 500 lines acceptable.
Over 500 lines: move content to a `references/` subdirectory, link from Skill.md.

---

## 3. living-checklist.md — Specification

### Header (Required)

```markdown
# Living Checklist — <Skill Name>

**Purpose:** Accumulated learnings. Extended after every session.
```

### Entry Format (Required)

Every entry follows exactly this format:

```markdown
### [YYYY-MM-DD] — [Task context]
**Learning:** What was discovered / what failed
**Why it matters:** Context and consequences
**Rule:** Concrete actionable guideline for future sessions
```

### Quality Criteria for Entries

A good entry is:
- **Specific** — not "triggers can be wrong", but "Hue bulbs report `off` briefly before `on` on boot — use `from: [unavailable, unknown, 'off']`"
- **Actionable** — the Rule must be directly applicable, not an abstract principle
- **Contextualized** — date and task type, so future instances can judge relevance
- **Model-agnostic** — avoid model-specific phrasing; the entry should be useful for any instance

### What Does NOT Belong in living-checklist

- Facts that change frequently (→ update Skill.md System Reference instead)
- Task-specific details with no reuse value
- Personal preferences without reasoning

### Growth

The living-checklist grows without limit. Older entries are never deleted.
Above 50 entries: optional `## Distilled Rules` summary section at the top;
chronological entries remain intact below.

---

## 4. revisionslog.md — Specification

### Format

```markdown
# Revision Log — <Skill Name>

| Date | Version | Change | Reason |
|------|---------|--------|--------|
| YYYY-MM-DD | 1.0 | Initial skill | Created from <source> |
```

### When to Update

Only when `Skill.md` changes. Changes to `living-checklist.md` are tracked
via Git commits — no revisionslog entry needed.

### Versioning

- 1.0 — initial skill
- 1.x — corrections, additions without structural change
- 2.0 — structural rewrite, new process, new stop criteria

---

## 5. Session Rituals (Required)

### Session Start

Every use of a Living Skill begins with:

1. Read `Skill.md` — understand the approach and context
2. Read `living-checklist.md` — load accumulated knowledge
3. Apply relevant checklist entries to the current task

This step is not optional. A skill used without reading the living-checklist
ignores the core promise of the framework.

### Session End

Every use ends with:

1. Identify new learnings:
   - What worked surprisingly well?
   - What failed?
   - What pattern emerged that might repeat?
2. Write entries to `living-checklist.md` (format: see Section 3)
3. Update `revisionslog.md` if `Skill.md` was changed
4. Git commit following convention: `<Instance>: <Skill-Name> — session [YYYY-MM-DD]`

**If nothing new was learned:** No entry required. An empty session is better
than a meaningless entry.

---

## 6. Ralph Loop — Application Rules

### When to Apply

| Task type | Ralph Loop? |
|-----------|-------------|
| Complex analysis, research | Yes — 2–4 iterations |
| Debugging with unclear root cause | Yes — until cause found |
| Simple configuration change | No |
| Writing documentation | No |
| Adversarial review | Yes — core of the pattern |
| Known problem with known solution | No |

### If a Skill Uses Ralph Loop: Required Skill.md Content

```markdown
## Stop Criteria

| Category | Threshold |
|----------|-----------|
| [Criterion 1] | [Value] |
| [Criterion 2] | [Value] |

STOP when: All criteria met AND minimum [N] iterations completed.
Maximum iterations: [M]
```

Stop criteria are defined BEFORE the session starts, not after.

### Iteration Documentation

After each iteration, briefly record:
```
Iteration [N]: [N] open issues — [main problems] → [what to check next]
```

---

## 7. Multi-Instance Sync

### Core Rule

Git is the single source of truth. All instances read from and write to the same repository.
No instance holds state outside of Git (except local runtime variables).

### Write Boundaries (Team Discipline)

Each instance writes **only to its own designated area** — typically a `Team Memory/<instance>/`
or equivalent folder. Other instances' memory areas are read-only.

**Why this matters:** Each instance is responsible for documenting what *it* did, so others
can read it. If Agent A writes into Agent B's memory, the authorship signal breaks down and
the memory becomes unreliable. Even if a task seems to call for it, no agent writes for another.

The canonical pattern:
```
Team Memory/
  instance-a/    ← Instance A writes here; B and C read-only
  instance-b/    ← Instance B writes here; A and C read-only
  instance-c/    ← Instance C writes here; A and B read-only
  shared/        ← All instances read; changes require explicit coordination
  skills/        ← Skills are shared; living-checklist entries by any instance are welcome
```

Exception: `skills/` and `shared/` are collaborative — any instance may contribute.
Living-checklist entries belong to the skill, not the instance.

### Commit Convention

```
<Instance-Name>: <Skill-Name> — <short description> [YYYY-MM-DD]
```

Examples:
```
Claude-Mac: advocatus-diaboli — FDP analysis session [2026-04-10]
Claude-Proxmox: home-assistant — Hue bulb trigger bug [2026-04-03]
Codex-Instance-1: home-assistant — automation debugging [2026-04-15]
```

### Conflict Resolution

On merge conflicts in `living-checklist.md`: **keep both entries**.
Never delete another instance's entries. When in doubt, append rather than merge.

On conflicts in `Skill.md`: manual resolution by a human, then commit.

### Instance Identity in Entries

Entries in living-checklist.md do NOT need instance identification.
The learning belongs to the skill, not the instance.
Instance identity is visible in the Git commit — that is sufficient.

---

## 8. Skill Types in Detail

### Type A: Behavioral Skill

**Purpose:** Defines *how* an agent approaches a class of problems.

**Characteristics:**
- Skill.md describes methodology, not facts
- Ralph Loop frequently integrated
- living-checklist accumulates patterns and errors in approach
- Generalizable across instances and models

**Reference:** `examples/advocatus-diaboli/`

### Type B: Domain Skill

**Purpose:** Stores *what works* in a specific technical or project domain.

**Characteristics:**
- Skill.md is a structured reference (access details, configuration, standard procedures)
- Ralph Loop optional; recommended when debugging
- living-checklist accumulates bug fixes, pitfalls, proven solutions
- Specific to one context (infrastructure component, codebase, system)

**Reference:** `examples/home-assistant/`

---

## 9. Quality Checklist for New Skills

Before the first commit of a new Living Skill:

- [ ] `Skill.md` has complete frontmatter (name, description, type)
- [ ] description is specific and "pushy" — no undertriggering
- [ ] Session Start ritual is explicitly described
- [ ] Session End ritual is explicitly described
- [ ] `living-checklist.md` has at least one seed entry (do not start empty)
- [ ] `revisionslog.md` exists with initial 1.0 entry
- [ ] If Ralph Loop: stop criteria are defined
- [ ] Location in repository matches type

---

## 10. Scripts and Executable Code

### When to Add a `scripts/` Directory

Add scripts to a Living Skill when a task is:
- **Deterministic** — the same input always produces the same output
- **Repetitive** — the agent would write the same code every session
- **Verifiable** — the result can be checked programmatically

Examples: health checks, data collection, status reports, configuration validation,
file transforms, API calls with fixed parameters.

Do NOT use scripts for tasks that require judgment, interpretation, or context.
Those belong in Skill.md as instructions, not in scripts.

### Supported Script Types

Living Skills support any executable the agent's environment can run:

| Type | Use for |
|------|---------|
| Shell (`.sh`) | System tasks, Git operations, service checks |
| Python (`.py`) | Data processing, API calls, report generation |
| Any other executable | Anything the agent's environment supports |

### How Scripts Integrate with Skill.md

Reference scripts explicitly in Skill.md — don't assume the agent will discover them:

```markdown
## Process

### Step 1 — Check system status
Run `scripts/check-status.sh` and review the output before proceeding.
If the status check fails, do not continue — investigate the error first.

### Step 2 — Collect data
Run `scripts/collect.py --date today` to gather fresh data.
Output is written to `data/latest.json`.
```

### Scripts and the Learning Layer

Scripts don't replace the living-checklist — they complement it.
When a script is added, modified, or found to have edge cases, write
a living-checklist entry explaining why.

Example entry after adding a script:
```
### 2026-04-10 — Added status check script
**Learning:** Manual status checks were taking 5 minutes of agent time per session.
The check is deterministic — same commands every time.
**Why it matters:** Automating the repetitive part frees the agent to focus on interpretation.
**Rule:** Run `scripts/check-status.sh` at session start before reading living-checklist.
```

### Dependency Declaration

If a script requires external packages, document them at the top of the script
and in Skill.md:

```markdown
## Requirements

- Python >= 3.10
- `requests` library (`pip install requests`)
- `jq` (for shell scripts that parse JSON)
```

### Security Note

Scripts in a shared Living Skills repository are executed by agents on their local machines.
**Review all scripts before running them**, especially when pulling from a shared remote
that other instances (or other people) can write to.

Never store credentials, tokens, or secrets in scripts. Use environment variables.

---

## 11. What Living Skills Are Not

**Not a RAG system.** There is no vector search, no embedding database.
The framework is intentionally simple: Markdown + Git + the LLM's reading ability.

**Not an orchestration framework.** Living Skills define no agent routing,
no tool calls, no prompt chaining logic. They are knowledge and behavior containers.

**Not a replacement for documentation.** Living Skills add a learning layer
on top of existing documentation. They do not replace system docs, ADRs, or READMEs.

**Not magic.** The quality of a Living Skill depends on instances consistently
following the session rituals. Without discipline in writing back, the system
degrades to static files.
