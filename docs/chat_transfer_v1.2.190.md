# Chat transfer — UI Mihomo Ultra v1.2.190

Continue from v1.2.190.

Current focus: provider access link management for panels that will be hidden from the Internet and opened locally through SSH tunnels on the PC.

Facts:

- SSL source must remain subscription URL, not panel URL.
- Public panel Internet URL is retained as metadata for manual transition.
- SSH/local panel URL is manually filled, usually as `http://127.0.0.1:<port>/...` on the PC.
- v1.2.190 is UI-only: provider names are displayed as badges, table columns are fixed/aligned, URL inputs are shorter.
- Do not touch Mihomo core, TUN, QoS/routing, users-db limits, shapers.db, router reboot, Home Assistant, HA DB, native HA Energy, or SmartLife boiler unless the user explicitly asks.

Next likely step: visually verify the providers table after the UI update and then decide whether to add per-provider validation/status hints for SSH/local panel URLs.
