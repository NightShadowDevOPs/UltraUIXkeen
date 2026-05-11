# RULES_DIGEST

- Keep command output compact: target 10–15 lines.
- Do not mutate router runtime unless the user explicitly approves.
- Do not reboot router.
- Do not touch Mihomo core, TUN, QoS/routing, provider SSL checks, users-db or shapers.db for UI-only changes.
- For router-agent/runtime fixes, use raw/manual installer path; the UI updater does not automatically deliver agent scripts.
- No secrets, tokens or full private URLs in docs/transfer packages.
- Maintain separate release, docs and transfer ZIP artifacts.
