# Release v1.2.180 — zash-agent watchdog

## Scope

Adds a scoped watchdog for `zash-agent` on Netcraze router. The watchdog checks `status` and `ha_snapshot`, then restarts only the agent `uhttpd` when endpoints are stuck.

## What changed

- Added `router-agent/restart-agent.sh`.
- Added `router-agent/watchdog.sh`.
- Added `router-agent/install-watchdog.sh`.
- Added scripts:
  - `scripts/apply-zash-agent-watchdog-v1.2.180.sh`
  - `scripts/check-zash-agent-watchdog-v1.2.180.sh`
  - `scripts/rollback-zash-agent-watchdog-v1.2.180.sh`
  - `scripts/backup-zash-agent-watchdog-v1.2.180.sh`
- UI package version bumped to `1.2.180`.

## Safety

Does not change Mihomo core, TUN, QoS semantics, routing rules, provider SSL checks, Home Assistant, or router reboot behavior.

## Runtime defaults

- Base URL: `http://192.168.0.1:9099/cgi-bin/api.sh` unless overridden by `ZASH_AGENT_BASE_URL`.
- Cron schedule: every 2 minutes.
- Failure threshold: 2 failed checks before restart.
- Restart cooldown: 300 seconds.
- Logs: `/opt/var/log/zash-agent/watchdog.log` and `/opt/var/log/zash-agent/restart-agent.log`.
