# CHANGELOG

## v1.2.181 — zash-agent watchdog

- Added scoped restart helper for zash-agent uhttpd.
- Added watchdog that validates `status` and `ha_snapshot` before deciding to restart.
- Added cron installation with lock, fail threshold and restart cooldown.
- Added apply/check/rollback/backup scripts for watchdog deployment.
- No changes to Mihomo core, TUN, QoS semantics, routing rules or provider SSL checks.

# Changelog

## v1.2.181 — normalized release package after v1.2.178 hotfix

- Merged the agent-only `v1.2.178` lightweight apply fix into the main release package.
- Kept installed zash-agent marker at `0.6.37`.
- Replaced full `/opt/zash-agent` tar backup flow with lightweight file backup in current apply/backup scripts.
- Added current `apply`, `check`, `rollback` and `backup` scripts for `v1.2.181`.
- Removed stale root transfer/scratch artifacts from the release archive.
- Fixed stale documentation references to older UI/agent versions.
- Replaced literal NUL bytes in `router-agent/install.sh` with textual `\000` escaping.
- Added separate docs and transfer packages according to universal release rules `v9.10.2`.
- Did not change Mihomo core, TUN, QoS semantics, routing rules or provider SSL checks.

## v1.2.176 — release hardening after strict audit

- Kept runtime router-agent code at `0.6.35`; no traffic, HA contract, provider SSL check, TUN, QoS or Mihomo core behavior was changed.
- Added concise smoke checker `scripts/check-zash-agent-v1.2.176.sh` with markers for `status`, `ha_snapshot` and `mihomo_providers`.
- Added scoped apply script `scripts/apply-zash-agent-v1.2.176.sh` that backs up `/opt/zash-agent`, installs the packaged agent and runs the concise checker.
- Added rollback helper `scripts/rollback-zash-agent-v1.2.176.sh` for the latest `/opt/zash-agent.backup-v1.2.176-*` or `/opt/zash-agent.backup-v1.2.175-*` backup.
- Clarified docs/audit status: the old `ha_snapshot` CGI timeout/502 issue is **fixed in v1.2.174**, not an open runtime risk.
- Added formal release documentation package `release-docs-ui-mihomo-ultra-v1.2.176.zip`.


## v1.2.175 — zash-agent deployment path and scoped restart hotfix

- `router-agent` bumped to `0.6.35`.
- Fixed release/application assumption: project files may live in `/opt/etc/mihomo`, while installed runtime agent lives in `/opt/zash-agent`.
- Added `scripts/apply-zash-agent-v1.2.175.sh` for direct `/opt/zash-agent` patching from an unpacked release folder.
- Added `scripts/check-zash-agent-v1.2.175.sh` for repeatable smoke diagnostics.
- Updated generated `/opt/etc/init.d/S99zash-agent stop`: no more broad `killall uhttpd`; stop is scoped to `/opt/zash-agent/www` processes.
- Hardened generated `/opt/zash-agent/start.sh` PID check: a stale/foreign PID no longer blocks a real start.
- Kept HA export contract, provider checks, Mihomo config, QoS/shaper, TUN and live traffic path unchanged.

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


## v1.2.177 — router-agent HA strict JSON hotfix

Закрыт риск невалидных HTTP responses для Home Assistant: строки `shape`, `wireguard-route` и другой stdout от shell helpers больше не могут попасть перед `Content-Type: application/json`. Добавлены безопасная сортировка без `sort -o` и strict wrapper для HA endpoints. Агент: `0.6.36`.

