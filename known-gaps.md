# Living Skills — Known Gaps and Open Questions

Open design questions without a resolved solution.
Do not implement without thinking through the implications first.

---

## [2026-04-11] Human-Readable Layer as Two-Way Channel

**Status:** Partially solved for Siyuan — open for other tools

**Problem:** The sync between Git and a human-readable knowledge base (Siyuan, Obsidian, Notion)
is currently one-directional:

```
Git ──(sync script)──→ Knowledge Base    ✓  Agents write → Human reads
Git ←────────────────  Knowledge Base    ✗  Human writes → Agents don't see it
```

Everything agents write to Git lands automatically in the knowledge base (via post-merge hook).
But when a human adds notes, corrections, or ideas directly in the knowledge base,
that does not flow back to Git — and agents never see it.

**Known approaches:**
- Dedicated "inbox" notebook/page in the knowledge base that agents check at session start via API
- Reverse-sync script (knowledge base export → Git commit)
- Agent queries knowledge base via MCP/API as part of session-start ritual

**Siyuan:** MCP access (`siyuan-mcp`) makes the inbox approach technically feasible.
See `Infrastructure/skills/siyuan/` for setup guidance.

**Notion / Obsidian / Logseq:** Same problem, different APIs. Contributions welcome.

---

## [2026-04-11] Context-Dependent Tool Identity

**Status:** No general solution — workarounds documented

**Problem:** Global agent configuration (e.g. `~/.cursor/rules/identity.mdc` with `alwaysApply: true`)
applies the team identity in ALL repositories — including private projects without team context.

**Desired behavior:**
```
Private repo    → no team identity, normal agent behavior
Team repo       → team identity activated
```

**Root problem:** The trigger must come from the repo ("I am a team repo"),
the identity must come from global config ("that is who I am") —
but the connection between them is missing.

**Possible approaches:**
- Marker file in repo (`.llm-team`) + conditional rule description — reliability untested
- Repo-scoped global rules — not natively supported by most tools
- Manual activation at session start — simple but not automatic

**Scope:** Affects any user running this framework alongside private projects.
Requires tool-specific testing.

---

## [open] Checklist Conflict Resolution at Scale

**Status:** Not yet encountered — worth anticipating

**Problem:** When multiple instances write to the same `living-checklist.md` in parallel,
Git can produce merge conflicts. The append-only convention reduces this significantly,
but does not eliminate it entirely.

**Current guidance:** Keep both versions — never delete another instance's entries.
See `setup/sync-setup.md` for conflict resolution steps.

**Open question:** Should checklist entries carry instance attribution?
(`**Instance:** Claude-Mac`) to make conflicts easier to resolve and contributions traceable.
