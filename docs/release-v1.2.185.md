# UI Mihomo Ultra v1.2.185 — Strict Output Cache Fallback Hotfix

## Scope

This release fixes direct Home Assistant router contract endpoints that could return `strict-output-violation` even while the generated component cache was valid.

## Root cause observed on router

- `ha_snapshot` top-level response was alive and returned `ok: true`.
- Direct `ha_traffic` returned `ok: true`.
- Direct `ha_status`, `ha_users`, and `ha_qos` returned `strict-output-violation`.
- `ha-strict.log` showed `strict_no_header=true` with `rc=0`.
- After direct endpoint calls, `ha_snapshot` could serve fresh nested component data from cache.

## Change

- Added a strict wrapper fallback for `ha_status`, `ha_traffic`, `ha_users`, and `ha_qos`.
- If a heavy endpoint generates a valid cache but does not emit HTTP headers through the strict wrapper, the wrapper now returns the cached JSON instead of a synthetic `strict-output-violation` response.
- Added `router-agent/install-strict-hotfix.sh` for raw/manual router deployment.
- Added compact check/apply/backup/rollback scripts for the strict endpoint hotfix.

## Safety boundaries

Not changed:

- Mihomo core
- TUN
- QoS/routing rules
- provider SSL checks
- users-db / shapers.db
- router reboot behavior
- zash-agent runtime marker (`0.6.37`)
- watchdog/restart/maintenance logic

## Expected result

After installing the hotfix:

- `ha_status`, `ha_traffic`, `ha_users`, `ha_qos` should no longer return `strict-output-violation` when their cache is valid.
- `ha_snapshot` remains the preferred Home Assistant source.
- Watchdog remains on `POLICY=transport_ok` and should not restart the agent because of nested bundle diagnostics.
