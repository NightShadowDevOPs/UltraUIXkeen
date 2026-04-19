# Changelog

## v1.2.142 — HA snapshot freshness helpers and no-data UX

- raised UI to `1.2.142`
- kept `router-agent` at `0.6.31` — no agent/API payload changes in this release
- kept the Home Assistant JSON contract **unchanged**; `ha_snapshot` / `ha_status` / `ha_traffic` / `ha_users` / `ha_qos` payload shape was not touched
- added Home Assistant template helpers for snapshot freshness and age (`snapshot`, `traffic`, `users`, `qos`)
- refreshed the example Home Assistant dashboard so stale / delayed data is visible without hammering the router harder
- updated handoff docs, release plan, request ledger and project memory for the next chat

## v1.2.141 — project memory export and docs freeze

- raised UI to `1.2.141`
- kept `router-agent` at `0.6.31` — no agent/API payload changes in this release
- **did not change** the Home Assistant JSON contract or payload structure
- exported the accumulated project context into docs: added project memory, request ledger, current live state, and synced chat-transfer materials
- refreshed release plan, HA handoff docs, chat-transfer docs, and examples around the current `ha_snapshot`-based integration

## v1.2.140 — router-agent install hotfix

- raised UI to `1.2.140`
- raised `router-agent` to `0.6.31`
- fixed drift between `api.sh` and the embedded CGI payload inside `router-agent/install.sh`
- `ha_snapshot` is now included in the installer-delivered router CGI, so a router updated from `install.sh` really gets the aggregated HA endpoint
- kept the Home Assistant package on the single-resource `ha_snapshot` model introduced in the previous release

## v1.2.139 — aggregated HA snapshot bundle

- raised UI to `1.2.139`
- raised `router-agent` to `0.6.30`
- added aggregated `ha_snapshot` endpoint in `api.sh`
- switched Home Assistant package to a single REST resource that feeds template sensors from the aggregated bundle
- updated docs, handoff packs and sample JSON for the HA export contour
