# Changelog

## v1.2.174 — HA snapshot anti-timeout hotfix

- `router-agent` bumped to `0.6.34`.
- Fixed `cmd=ha_snapshot` returning `502 Bad Gateway` under `uhttpd` CGI timeout.
- `ha_snapshot` no longer rebuilds all heavy HA-export components synchronously before sending headers.
- Added cache-only/stale-safe bundled response mode: `cache_mode:"stale-while-refresh"`.
- Added background cache refresh under lock `/tmp/zash-ha-snapshot-refresh.lock`.
- Added per-component cache-miss stubs with `ok:false`, `stale:true`, `cache_miss:true`, `component:<name>`.
- Preserved existing component contracts for `ha_status`, `ha_traffic`, `ha_users`, `ha_qos`.
- Did **not** change live traffic path, provider SSL checks, Mihomo core, TUN, QoS, routing rules, polling cadence or HA entity naming.

## v1.2.173 — zash-agent startup self-call hotfix

- `router-agent` bumped to `0.6.33`.
- Fixed startup fragility where `start.sh` called `cmd=rehydrate` through the agent's own HTTP endpoint.
- Startup refresh now runs directly as a CGI shell command.
- `ssl-refresh.sh` runs `cmd=ssl_cache_refresh` directly as CGI instead of calling the agent HTTP endpoint from cron.
- `S99zash-agent stop` cleans stuck `uhttpd` and `api.sh` processes more reliably.
- Installer auto-detects and fills `MIHOMO_CONFIG` for existing `agent.env` when it is missing or points to a non-existing file.
- UI polling, HA/export contract, provider SSL checks as a feature, live traffic path and TUN were intentionally left unchanged.

## v1.2.172 — traffic calmer service and empty states

- `Трафик -> Устройства`: added calmer service-state summary.
- `Трафик -> Пользователи`: added service-state summary for saved labels, browser traffic buckets and live runtime.
- Empty states became explicit: loading, unavailable agent, no saved labels/runtime devices, no matches under current filters.
- Added reset actions for filters/focus/diagnostic slices.

## v1.2.171 — traffic page ergonomics

- Improved traffic tables readability.
- Added clearer grouping and diagnostic hints for user/device traffic.

## v1.2.170 — HA export bridge documentation

- Updated HA export bridge documentation and transfer notes.

## v1.2.169 — router to HA contract

- Stabilized full router-to-HA contract.
- `ha_snapshot` is the recommended normalized source for HA/SmartLife.
- `*_bps` in contract means bytes/sec.
- `counts.qos_enabled` is a counter, not a boolean.
