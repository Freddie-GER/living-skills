# Revision Log — Home Assistant

| Date | Version | Change | Reason |
|------|---------|--------|--------|
| 2026-04-10 | 1.0 | Initial Living Skill (anonymized example) | Created from real homelab instance |
| 2026-03-30 | — | Ceiling light automation: trigger switched to `light.*` | Zigbee connectivity entities don't exist in current Hue driver |
| 2026-03-30 | — | TV exit scene: smart plug action wrapped in sun condition | Avoid turning on lights during daytime |
| 2026-04-03 | — | Power-on trigger: added `'off'` to `from:` list | Zigbee bulb boot sequence: brief `off` before `on` |
