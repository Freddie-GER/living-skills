# Living Checklist — Advocatus Diaboli

**Purpose:** Accumulated review patterns from real sessions. Extended after every use.

---

### [YYYY-MM-DD] — [Analysis type]
**Learning:** What pattern was found / what failed
**Why it matters:** Structural reason it was missed
**Rule:** Concrete check to apply in future sessions

---

## Entries

### 2026-04-10 — Political Strategy Analysis

**Learning:** Historical narratives adopted as facts without verification
**Why it matters:** With established political actors, large bodies of published material exist — first-pass output aggregates this material without questioning whether the narratives themselves are accurate
**Rule:** For every historical causal claim, ask: "Who says this, and who would disagree?"

**Learning:** Opportunity spaces dismissed as "saturated" without checking whether saturation is real or perceived
**Why it matters:** Competitive analysis looks at existing actors, not at unclaimed combinations
**Rule:** For every "saturated space": Is there a combination of two topics that no actor credibly occupies?

**Learning:** Audience analyses conflate self-image and external perception without separation
**Why it matters:** "Party X is perceived as a clientelist party" is external perception — but is treated as structural fact
**Rule:** Always separate: What is self-image, what is external perception, what is verifiable reality?

---

### 2026-04-11 — Meta: Living Skills Framework Self-Onboarding (Cursor)

**Learning:** "Framework + docs = complete self-onboarding" is false — team charter (who writes where) lives outside the Living Skills spec, e.g. only in the host repo's CLAUDE.md or equivalent
**Why it matters:** Living Skills addresses Git/rituals/skill paths, not organization-specific identity and folder rules of the host repo
**Rule:** Before claiming "self-onboarding possible", ask: Which rules are defined **in the host repo** (Team Memory, CLAUDE.md) vs. **in the framework** itself?

**Learning:** Tutorial paths (`skills/<name>/`) diverge from real-world layouts (e.g. `Team Memory/skills/<name>/`) — a new instance can read the wrong relative path
**Why it matters:** Framework spec and templates assume `skills/` at repo root; forks with different structures are not marked as deviations
**Rule:** At onboarding step one, verify physically where `Skill.md` lives (via `find` or README) — do not assume from framework examples

**Learning:** `setup/agent-configuration.md` marks Cursor config as **untested** — yet it was used as-is for a production self-onboarding
**Why it matters:** Assumed parity between Claude Code and Cursor without validating differences (sandboxing, `git push` access, hook behavior)
**Rule:** With Cursor: explicitly verify — unsandboxed shell, `git push` once manually confirmed, rule file set to `alwaysApply` vs. context-specific

---

*Further entries follow after each session.*
