# Living Skills — Known Gaps and Open Questions

Open design questions without a resolved solution.
Do not implement without thinking through the implications first.

---

## [2026-04-11] Human-Readable Layer as Two-Way Channel

**Status:** Solved for Siyuan (with known limitation) — open for other tools

**Problem:** The sync between Git and a human-readable knowledge base (Siyuan, Obsidian, Notion)
was one-directional: agents write to Git, sync pushes to the knowledge base, but human
edits in the knowledge base never flow back to agents.

**Solution (Siyuan):** Two mechanisms working together:

1. **Diff-before-write sync** (`sync-to-siyuan.sh`): Only updates documents whose content
   actually changed (word fingerprint comparison). Unchanged documents keep their Siyuan
   timestamp. This is the key enabler — without it, every sync refreshes all timestamps
   and human edits become invisible.

2. **Human edit detection** (`check-siyuan-edits.sh`): At session start, compares Siyuan
   document timestamps against the last Git commit timestamp (+ 2-minute buffer for sync
   delay). Any document with a newer timestamp was edited by a human. The agent reads the
   edits, incorporates them into the session, and the normal session-end flow (git push →
   sync) writes the merged result back to both Git and Siyuan.

```
Session start:  git pull → check-siyuan-edits.sh → agent sees human edits
Session work:   agent incorporates human input into its work
Session end:    git push → sync-to-siyuan.sh → complete state in both systems
```

**Known limitation:** ~24% of documents have Markdown roundtrip differences (Siyuan's
parser changes formatting on export). These get rewritten every sync and show as false
positives in the edit check. The affected documents are consistent and predictable.
See `Infrastructure/skills/siyuan/Skill.md` for details.

**Notion / Obsidian / Logseq:** Same problem, different APIs. The same timestamp-based
approach should work if the knowledge base exposes document modification timestamps
and supports content comparison before write. Contributions welcome.

---

## [2026-04-12] Cursor Does Not Reliably Execute Session Rituals

**Status:** Known limitation — no solution at the framework level

**Problem:** Cursor reads `.cursor/rules/*.mdc` files correctly, but does not enforce
session rituals (pull before starting, commit after finishing) with the same reliability
as Claude Code.

Claude Code executes `CLAUDE.md` before every response — it cannot skip the instructions
without violating its own context. Cursor has no equivalent lifecycle hook. The rules
are loaded as guidelines, not enforced pre/post-conditions.

In practice: Cursor has been observed starting work without pulling first and completing
sessions without committing — even when the rules explicitly require both.

**Root cause:** Structural gap in Cursor's execution model, not a configuration problem.
The `.cursor/rules/` format and content are correct. Cursor simply does not enforce
them the way Claude Code enforces `CLAUDE.md`.

**Impact:** In multi-instance setups with Cursor, uncommitted local changes can block
a `git pull` on the next session. This requires manual conflict resolution and loses
the seamless handoff the framework is designed to provide.

**Mitigation:** Human oversight at session start and end when Cursor is involved.
A brief reminder ("pull first", "commit now") is usually sufficient.
Documented in [agent-configuration.md](setup/agent-configuration.md).

**What would fix it:** A Cursor feature equivalent to Claude Code's `UserPromptSubmit`
hook — a mechanism to execute commands before Cursor responds. Not available today.

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
