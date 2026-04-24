# Living Checklist — Token-Aware Developer Brief

**Purpose:** Application experience layer — accumulated token-optimization patterns from real sessions.
Grows with every session. Never merged back into Skill.md.

---

## Entry Format

```
### [YYYY-MM-DD] — [Task type / context]
**Learning:** What was discovered / what was surprising
**Why it matters:** Structural reason this happens repeatedly
**Rule:** Concrete guideline for next similar session
```

---

## Entries

### 2026-03-12 — Multi-source research with 4 sub-agents

**Learning:** Spawning all 4 Explore agents simultaneously flooded the main context with overlapping results — significant deduplication overhead
**Why it matters:** Parallel agents are efficient for independent search areas, but become expensive when search spaces overlap and results need cross-referencing in context
**Rule:** Before spawning parallel agents: explicitly define non-overlapping search scopes. If scopes might overlap, run sequentially and pass first results as context to the next.

---

### 2026-03-28 — Coding task, Caveman Lite mode

**Learning:** Caveman Lite reduced response length ~55% with zero quality loss on a pure implementation task — but caused a user confusion incident when an error message was compressed too aggressively
**Why it matters:** Error messages contain structural information that gets lost when compressed; "permission denied" and "permission denied writing to /etc/hosts" are not the same message
**Rule:** Caveman mode must never compress error messages, stack traces, or diagnostic output — these are in the "Keep" category even in Ultra mode. Auto-clarity exception applies here.

---

### 2026-04-10 — Research task, Advisor pattern (2 calls)

**Learning:** Used Executor + Advisor pattern for a research task with only 2 advisor calls — the overhead of structuring inputs for the advisor cost more than the strategic value returned
**Why it matters:** The advisor pattern amortizes at ≥3 calls; below that threshold, the single-model approach produces better cost/value ratio
**Rule:** Before starting Executor + Advisor: estimate iteration count. If likely ≤2 advisor calls, use single capable model instead. Only commit to the pattern when ≥3 iterations are expected.

---

*Further entries follow after each session.*
