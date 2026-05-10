# PROJECT_SPEC — UI Mihomo Ultra / router-agent

UI Mihomo Ultra is a router UI and local router-agent integration for Netcraze Ultra / Mihomo monitoring and control.

Current runtime focus:

- zash-agent HTTP API on `192.168.0.1:9099`.
- Home Assistant Router Contract via `ha_snapshot` bundle.
- Watchdog and maintenance scripts installed under `/opt/zash-agent`.
- Safe raw/manual router-agent installers are required because UI updater delivers frontend bundle and does not reliably deliver runtime scripts.

v1.2.187 changes only router-agent `ha_snapshot` CPU/load mapping/cache behavior.
