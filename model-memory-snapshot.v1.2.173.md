# Model memory snapshot — UI Mihomo / Ultra

- Date: **2026-04-29**
- UI version: **v1.2.173**
- router-agent version: **0.6.33**

## Compact current state
- v1.2.173 is a router-agent hotfix release after a real incident: `uhttpd` listened on `192.168.0.1:9099`, direct CGI status worked, but HTTP requests to status/providers timed out and UI showed agent unavailable.
- Patch removes HTTP self-calls from agent internals: startup `rehydrate` and cron `ssl_cache_refresh` now run directly as CGI shell commands.
- Stop/start cleanup hardened for stale `uhttpd` and `api.sh` processes.
- Installer auto-detects `MIHOMO_CONFIG` for existing `agent.env` when missing/stale.
- UI polling, HA/export shape, provider SSL checks as functionality, live traffic path and TUN are unchanged.

## Hard rules
- Router IP is `192.168.0.1`.
- TUN remains disabled unless there is a separate tested scenario.
- Do not break provider SSL checks.
- Do not use `git pull` as the default router update path.
- Router command blocks must start with `clear`.
- If changing router-agent, sync versions in install.sh/status/docs.

## Later validation
- status endpoint responds quickly over LAN
- providers list appears in UI
- provider SSL checks still run
- HA `ha_snapshot` structure remains unchanged
- accumulated releases v1.2.169–v1.2.173 are checked together
