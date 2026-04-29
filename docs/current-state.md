# Current state — UI Mihomo / Ultra

- Date: **2026-04-29**
- UI version: **v1.2.173**
- router-agent version: **0.6.33**
- Main focus: stabilize `zash-agent` startup/stop behavior after the observed router-side hang where `uhttpd` was listening, direct CGI worked, but browser/UI HTTP requests timed out.

## What was done in v1.2.173
- `start.sh` no longer calls `cmd=rehydrate` via `http://<bind-ip>:9099/...` during startup.
- Startup rehydrate now runs directly as CGI: `REQUEST_METHOD=GET QUERY_STRING='cmd=rehydrate' /opt/bin/sh .../api.sh`.
- `ssl-refresh.sh` no longer uses the agent HTTP endpoint for cron refresh. It calls `cmd=ssl_cache_refresh&keep=1&cron=1` directly as CGI.
- `S99zash-agent stop` now performs graceful stop and then force cleanup for stuck `uhttpd` and `api.sh` processes.
- Fresh `start` cleans stale CGI children before launching new `uhttpd`.
- Installer can auto-detect the active Mihomo config and fill `MIHOMO_CONFIG` in existing `agent.env` if the variable is missing or stale.

## Why this matters
- The exact failure pattern was not “agent binary absent”: `uhttpd` was listening and direct CGI status returned JSON, but HTTP status timed out afterwards.
- The risky part was the agent calling its own HTTP endpoint during startup/cron while UI was polling status/providers.
- The patch removes those self-calls without changing live routing, TUN, provider SSL checks logic, HA/export structure or UI polling cadence.

## Current safety rules
- do not break automatic SSL-certificate checks for providers
- do not suggest `git pull` as the primary router update path; the built-in UI updater remains the main flow
- every router command block must begin with `clear`
- do not change the router-agent → Home Assistant data structure unless explicitly requested
- if `router-agent` changes later, sync version references in `install.sh`, status API and docs
- keep TUN disabled unless a separate real router scenario explicitly requires it

## Deferred validation checklist
- update/install package on router
- restart `zash-agent`
- verify `/cgi-bin/api.sh?cmd=status` returns quickly over `192.168.0.1:9099`
- verify provider list appears again in UI
- verify SSL cache/provider checks still work
- verify HA/export endpoints still expose the same shape
- later verify accumulated releases `v1.2.169`–`v1.2.173` together
