# LLM Team Framework — Known Gaps and Open Questions

Design questions without a solution yet. Do not implement anything here before thinking it through carefully.

---

## [2026-04-11] Siyuan as a Two-Way Channel

**Status:** TODO — no solution yet

**Problem:** The sync between Git and Siyuan is currently one-directional:

```
Git ──(sync hook)──→ Siyuan    ✓  agents write → human reads
Git ←────────────── Siyuan    ✗  human writes → agents don't see it
```

Everything agents write to Git lands in Siyuan automatically (post-merge hook).
But if a human writes notes, ideas, or corrections directly in Siyuan,
those don't flow back to Git — and agents don't pick them up at session start.

**Open questions:**
- Should Siyuan have a dedicated "inbox" notebook that agents check at session start via MCP?
- Should there be a reverse sync script (Siyuan export → Git commit)?
- Should agents query Siyuan via API/MCP as part of the session start ritual?
- How do we distinguish "human addition" from "already synced from Git"?

Tracking here until we have a clear answer.

---

## [2026-04-11] Context-Dependent Identity in Cursor

**Status:** TODO — no solution yet

**Problem:** The global identity file (`~/.cursor/rules/identity.mdc`) uses `alwaysApply: true` — which means Cursor assumes the team identity in **every** repo, including private projects.

**Desired behavior:**
```
Open private repo     → no team identity, normal Cursor
Open LLM Team repo   → activate team identity
```

The trigger must come from the **repo** ("I am a team repo"), the identity from **global config** ("this is who I am") — but the connection between the two is unsolved.

**Possible approaches under consideration:**
- A marker file in the repo (`.llm-team`) + `alwaysApply: false` with a matching description in identity.mdc — untested whether Cursor reliably handles this
- Per-team global rule files (`~/.cursor/rules/my-team.mdc`) scoped to a working directory — not natively supported by Cursor today
- Explicit activation: user tells Cursor their identity at session start — simple but not automatic

This affects any developer who uses the framework alongside private projects.
Needs Cursor-specific testing before a pattern can be recommended.

Tracking here until we have a clear answer.
