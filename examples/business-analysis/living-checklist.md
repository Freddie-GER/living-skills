# Living Checklist — Business Analysis

**Purpose:** Application experience layer — accumulated patterns from real BABOK sessions. Grows with every session. Never merged back into Skill.md.

---

## Entry Format

```
### [YYYY-MM-DD] — [Pattern type / domain context]
**Learning:** What was overlooked or went wrong
**Why it matters:** Structural reason it was missed
**Rule:** Concrete heuristic for the next session
```

---

## Entries

### 2026-01-22 — Security NFRs written at wrong altitude

**Learning:** Security non-functional requirements were stated as intent ("must be secure", "2FA required for sensitive actions") without naming the specific threat, the enforcement point, or a testable criterion. They read as complete but could not be verified by anyone.
**Why it matters:** Security NFRs are often copied from policy templates or stated by analogy to other projects. The link to the specific authorization model of *this* system is never made explicit, so a developer reading the NFR has no way to know what passing looks like.
**Rule:** Every security NFR must: (1) name the specific threat or violation it addresses, (2) state the enforcement point (schema constraint, server action guard — not just UI), (3) provide a binary pass/fail criterion. "Must be secure" is not an NFR.

---

### 2026-02-14 — Out-of-Scope section left empty

**Learning:** The Out-of-Scope table was skipped during analysis because "nothing was obviously out of scope." Stakeholders later raised items they had assumed were included, requiring renegotiation and rework mid-build.
**Why it matters:** Teams document what they build, not what they explicitly exclude. Exclusions feel obvious until they aren't, and the cheapest place to surface scope disagreement is before development starts.
**Rule:** Always populate Out-of-Scope. If something was raised in discussion and rejected, it must appear there with a reason. An empty OOS table after Step 7 means the step was skipped, not that nothing is out of scope.

---

### 2026-03-30 — Stakeholders without a UI written as portal users

**Learning:** User stories were written as "As a [stakeholder], I want to…" for two stakeholder groups (an external auditor and a downstream notification recipient) who had no UI in the system — they interacted only through emailed reports. The acceptance criteria became untestable because there was no interface to test against.
**Why it matters:** The standard "As a [role]…" template implies a UI. Stakeholders without a UI fit the template by accident and produce stories that nobody can build or test.
**Rule:** For stakeholders without a direct UI, express their needs as: (1) NFRs with measurable enforcement criteria, and (2) notification/event stories written from the system's perspective ("System sends a structured notification to [stakeholder] when [event] occurs"). Do not write "As [non-UI stakeholder], I want to…" unless an interaction surface actually exists.

---

### 2026-05-07 — Glossary written after the user stories

**Learning:** Domain-specific terms were used in user stories and acceptance criteria before being defined. Reviewers and developers built different mental models from the same words, and several acceptance criteria were implemented against the wrong interpretation.
**Why it matters:** Domain terms feel obvious to the person who knows the domain. They aren't obvious to reviewers, downstream developers, or a future session returning to the document cold.
**Rule:** Start the Glossary at the end of Step 1, before any user stories are written. When a new domain term first appears in a story or requirement, add it to the Glossary immediately. Never assume a term is self-explanatory — the ones that feel most obvious cause the most review confusion.

---

*Further entries follow after each session.*
