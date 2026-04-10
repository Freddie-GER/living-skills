# Living Checklist — Home Assistant

**Purpose:** Accumulated learnings from real sessions. Extended after every use.

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

### 2026-03-30 — Zigbee trigger debugging

**Learning:** `sensor.<device>_zigbee_connectivity` entities do not exist in the current
Hue integration driver. Automations that trigger on these entities are silently broken —
no error, they simply never fire.
**Why it matters:** Easy to miss because HA shows no error. The automation appears healthy
but never triggers.
**Rule:** When an automation never fires: first verify the trigger entity actually exists
in the States tab. Use `light.*` entities directly instead of `sensor.*_connectivity`.

---

### 2026-03-30 — YAML `from:` syntax in state triggers

**Learning:** `from:` in state triggers must be a YAML list, not a scalar.
`from: unavailable` (scalar) is accepted by HA but behaves inconsistently.
**Why it matters:** Hard to spot — the YAML is technically valid, but the trigger
may not fire in all expected situations.
**Rule:** Always write `from: [unavailable, unknown]` as a list. Never use scalar form.

---

### 2026-04-03 — Zigbee bulb boot sequence

**Learning:** Zigbee bulbs (e.g. Philips Hue) report a brief `off` state before `on`
when powered up via a physical wall switch. The actual state sequence is `off → on`,
not `unavailable → on`.
**Why it matters:** An automation designed to trigger on `unavailable → on` will miss
the real transition entirely when a wall switch is used.
**Rule:** For Zigbee bulb power-on triggers, use `from: [unavailable, unknown, 'off']`
to cover all three states that precede `on`.

---

### 2026-04-06 — HA restart re-triggers presence automations

**Learning:** On HA restart, `person.*` entities are restored from their last known state.
This generates a state-change event that fires any presence-based automation that watches
for that entity becoming `home`.
**Why it matters:** A room light turned on 2 hours after a restart looks like a bug
but is actually caused by the restart state-restore cycle.
**Rule:** After any HA restart, check the automation traces for unexpected presence
triggers. These are restart artifacts, not bugs. Long-term fix: add
`initial_state: false` to presence automations, or add a condition checking
that HA has been running for more than a few minutes before allowing the trigger.

---

*Further entries follow after each session.*
