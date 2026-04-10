---
name: "Home Assistant"
description: "Use for ANY Home Assistant work — debugging automations, adding new automations, entity configuration, integration setup, updates. Trigger: 'Home Assistant', 'HA automation', 'Zigbee', 'smart home', entity names."
type: "domain"
---

# Home Assistant — Living Skill

**Session Start:** Read `living-checklist.md` first — known pitfalls and proven solutions.

---

## System Reference

| Parameter | Value |
|-----------|-------|
| Container / Host | `<HA_HOST>` (e.g. a VM, container, or dedicated machine) |
| Installation | Docker `ghcr.io/home-assistant/home-assistant:stable` |
| Web UI | `http://<HA_HOST>:8123` |
| Config volume | `/var/lib/docker/volumes/hass_config/_data/` |
| Backup path | `<BACKUP_PATH>` (manual, before updates) |

---

## Devices & Entities

Adapt this table to your setup. Example structure:

| Entity | Device | Type |
|--------|--------|------|
| `light.<room>_ceiling` | Ceiling light | Zigbee bulb |
| `light.<room>_floor` | Floor lamp | Zigbee bulb |
| `light.smart_plug` | Smart plug | Binary switch (no dimming) |
| `media_player.tv` | Smart TV | Media player |
| `media_player.streaming_device` | Streaming box | Media player |
| `person.resident_1` | Primary resident | Presence tracking |
| `person.resident_2` | Secondary resident | Presence tracking |

**Smart plug note:** Binary devices (no dimming) are often used seasonally
(e.g. floor lamp vs. decorative light). When switching, remember to swap
which automations are active.

---

## Proven Approaches

### Writing Automations

- Always verify that trigger entities actually exist before writing automation YAML
- Use `from:` as a YAML list, never as a scalar (see living-checklist)
- Check the HA developer tools (States tab) to confirm entity names and current states
- Test triggers manually via Developer Tools → Events before going live

### Debugging an Automation That Never Fires

1. Check the automation trace (Settings → Automations → your automation → Traces)
2. Verify trigger entity exists and changes state as expected
3. Verify conditions evaluate to true at the moment you expect the trigger
4. Check if the automation is enabled

### Presence-Based Automations

- State restore on HA restart can re-trigger presence automations (see living-checklist)
- Test: restart HA and observe which automations fire unexpectedly

---

## Common Automation Patterns

### Light follows physical switch

```yaml
trigger:
  - platform: state
    entity_id: light.<zigbee_bulb>
    from: [unavailable, unknown, 'off']
    to: 'on'
condition:
  - condition: state
    entity_id: light.<smart_plug>
    state: 'off'
action:
  - service: light.turn_on
    entity_id: light.<smart_plug>
```

### TV scene (cinema mode)

```yaml
trigger:
  - platform: state
    entity_id: media_player.tv
    to: 'on'
action:
  - service: light.turn_on
    entity_id: light.<room_light>
    data:
      brightness_pct: 5
      color_temp: 500
      transition: 15
  - delay: "00:00:15"
  - service: light.turn_off
    entity_id: light.<smart_plug>
```

### Dead man's switch / inactivity alert

```yaml
trigger:
  - platform: time_pattern
    hours: "/1"
condition:
  - condition: template
    value_template: >
      {{ (now() - states.light.<entity>.last_changed).total_seconds() > 50400 }}
  - condition: state
    entity_id: input_boolean.alert_sent
    state: 'off'
action:
  - service: notify.<your_notification_service>
    data:
      message: "No activity detected for 14 hours."
  - service: input_boolean.turn_on
    entity_id: input_boolean.alert_sent
```

---

## Open TODOs

- [ ] Native push notifications via HA Companion App (iOS/macOS)
  — registers `notify.mobile_app_<device>` automatically after app install
  — allows `interruption-level: critical` to bypass silent mode
- [ ] [Add your own TODOs here]

---

## Session End

After each session: write new learnings, bug fixes, pitfalls, or proven solutions
to `living-checklist.md`.
Format: date, task context, learning, rule.
Update `revisionslog.md` if automations or configuration changed.
