# Living Checklist — Siyuan Knowledge Base

**Purpose:** Accumulated setup patterns, API quirks, and sync learnings. Extended after every session.

---

## Entry Format

```
### [YYYY-MM-DD] — [Task context]
**Learning:** What was discovered / what failed
**Why it matters:** Context and consequences
**Rule:** Concrete actionable guideline for future sessions
```

---

## Entries

### 2026-04-11 — Initial setup (self-hosted Docker)

**Learning:** The MCP config key for the Siyuan URL is `SIYUAN_URL`, not `SIYUAN_BASE_URL`
**Why it matters:** Wrong key causes silent failure — MCP loads but all API calls return connection errors
**Rule:** Always use `SIYUAN_URL` in MCP env config. Verify with a test query before trusting the connection.

---

### 2026-04-11 — Git → Siyuan sync debugging

**Learning:** Document HPath in Siyuan is derived from the first H1 heading in the `.md` file, not the filename
**Why it matters:** Renaming a file without updating the H1 creates a new document instead of updating the existing one — silent duplicate
**Rule:** When renaming a `.md` file, check whether the H1 heading also needs updating to keep the HPath stable.

---

*Further entries follow after each session.*
