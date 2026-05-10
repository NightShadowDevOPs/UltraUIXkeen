# Release v1.2.182 — Agent Restart Service Hotfix

## Scope

This is a router-agent hotfix. It updates only the zash-agent restart helper.

## What changed

- `router-agent/restart-agent.sh` now prefers the Entware init service path: `/opt/etc/init.d/S99zash-agent restart`.
- If service restart does not restore `status` and `ha_snapshot`, the helper falls back to the existing scoped restart path.
- The fallback remains limited to `/opt/zash-agent` uhttpd and stale CGI children.
- Added raw/apply helpers for install, check, backup and rollback.

## What was not changed

- Mihomo core was not changed.
- TUN was not changed.
- QoS, shaper and routing rules were not changed.
- Provider SSL checks/cache were not changed.
- `users-db.json` and `shapers.db` were not changed.
- Router reboot is not used.

## Runtime context before release

- zash-agent service exists: `/opt/etc/init.d/S99zash-agent`.
- Service supports `start|stop|restart`.
- Current process is uhttpd bound to `192.168.0.1:9099`.
- Watchdog and maintenance are installed and OK from v1.2.180/v1.2.181.
- `/opt/zash-agent` was reduced to about 154.7M after manual maintenance cleanup.
