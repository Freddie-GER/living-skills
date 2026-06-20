# Living Checklist — Secure Architecture

**Purpose:** Application experience layer — accumulated patterns from real reviews of authorization models. Grows with every session. Never merged back into Skill.md.

---

## Entry Format

```
### [YYYY-MM-DD] — [Pattern type / system context]
**Learning:** What was overlooked or went wrong
**Why it matters:** Structural reason it was missed
**Rule:** Concrete check for future sessions
```

---

## Entries

### 2026-02-08 — OTP added to a high-value approval flow

**Learning:** A second factor was added to the "approve transfer" action and treated as the security fix. The actual question — "is this actor entitled to approve this transfer at all?" — was never asked. OTP proved the actor was who they claimed to be, not that they had the right to approve.
**Why it matters:** Adding OTP feels like "adding security." The AuthN/AuthZ distinction collapses under time pressure when the flow already produces the expected behavior in the happy path.
**Rule:** "If the actor passes OTP but obtained their position through data manipulation rather than legitimate authorization, do they still get through?" If yes → Layer 1 violation. OTP confirms identity; it cannot confer entitlement.

---

### 2026-03-15 — Authorization routed through an editable contact field

**Learning:** Permission to act on a record was derived from a `contact_email` field on the record itself. The field was editable as part of normal data maintenance, which meant any routine "update record" operation silently transferred the permission to whoever's email was now in the field.
**Why it matters:** A field-based check looks like an authorization check — it uses real data, produces the right result under normal conditions, and is fast to implement. The attack surface only becomes visible when you ask what happens if the field value changes.
**Rule:** Authorization must anchor on a stable ID in a junction table with explicit Grant/Revoke and an audit trail — not on a master-data field that day-to-day operations can change. "Could a routine update silently transfer authorization?" — if yes, Layer 2 violation.

---

### 2026-04-02 — Separation of Duties enforced only in the UI

**Learning:** Two-party approval was implemented by hiding the "Approve" button from the same user who created the request. The backing server action accepted any authenticated request and did not check whether the caller was also the requester. SoD was bypassable by replaying the API call from a different session belonging to the same actor.
**Why it matters:** UI-level SoD is fast to build and visible in demos. The server-side guard is invisible and easy to forget — until someone scripts against the API.
**Rule:** "If I call this action directly via API/curl, bypassing the UI entirely, does SoD still hold?" If not → Layer 3 violation. SoD must be enforced in the server action or as a schema-level constraint, never only at the UI.

---

### 2026-05-19 — Junction table added, grant/revoke endpoint left unprotected

**Learning:** A previous finding was fixed by introducing an `actor_grants` junction table to anchor authorization. The grant action itself was protected, but the revoke + re-grant flow was reachable by any administrator role, including the requester's role. Changing *who can decide* turned out to be easier than performing *the decision itself*.
**Why it matters:** Fixing the immediate authorization problem feels complete. The meta-problem — who controls the authorization list — requires a second gate that didn't yet exist, and it's easy to ship the first fix and forget the second.
**Rule:** "Is modifying the authorization record at least as hard as performing the action it protects?" If not → Layer 4 gap. Flag it explicitly even if the second gate is deferred; document the residual risk so a future reader cannot mistake the partial fix for a complete one.

---

*Further entries follow after each session.*
