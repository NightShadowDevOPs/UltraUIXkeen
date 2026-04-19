# Changelog

## v1.2.146 — diagnostics slice ordering and row reasons
- raised UI package version to `1.2.146`
- in **Host QoS**, diagnostic slices now sort by severity first (live traffic / unlabeled / pending draft mismatch) instead of looking random
- in **Host QoS**, each row inside an active diagnostic slice now shows a short badge explaining why it landed there
- in **Traffic / Users**, diagnostic slices now sort by the most relevant signal for the active mode (blocked/limited first, higher usage first, stronger live traffic first)
- in **Traffic / Users**, each row inside an active diagnostic slice now shows a short reason badge such as `Нет привязок`, `QoS без runtime-IP`, `{percent} лимита`, `Live: rate`
- kept the Home Assistant bridge contract unchanged; no router-agent payload or export shape changes
- validation note: `npm run build` could not be completed in the container because dependencies are not installed here (`vite: not found`), so post-update manual UI checks are required

## v1.2.145 — diagnostics drill-in slices and sticky active state
- raised UI package version to `1.2.145`
- Host QoS diagnostic cards now open the full corresponding problem slice instead of focusing only the first host
- Traffic / Users diagnostic cards now open full problem subsets: missing devices, stored-only QoS, near-limit, active live traffic
- while a diagnostic slice is active in Traffic / Users, Top N truncation is bypassed so relevant rows stay visible
- toolbar now shows the active diagnostic state and offers a quick reset
- kept the Home Assistant bridge contract unchanged; no router-agent payload shape changes

## v1.2.144 — diagnostics cards for Host and Traffic workspaces
- raised UI package version to `1.2.144`
- added a new diagnostics card row in **Host QoS**: live traffic, unlabeled hosts, pending QoS drafts, current slice reset
- added a new diagnostics card row in **Traffic / Users**: missing devices, stored-only QoS, near-limit users, active live traffic
- cards are actionable: they open the matching host/user slice instead of being passive counters
- kept the Home Assistant bridge contract unchanged; no payload or structure changes were made for HA export
- validation note: local dependency install was unavailable in the container, so final safety check was done with TypeScript transpile parsing of modified Vue/locale files

## v1.2.143 — release packaging, transfer kit and workflow snapshot
- raised UI package version to `1.2.143`
- router-agent left unchanged at `0.6.31`
- added `docs/model-memory-snapshot.md` with a practical snapshot of remembered project rules and an explanation of how this memory should be used
- added `docs/workflow-rules.md` with the agreed release workflow: archives, commit block, router commands, checks, docs discipline
- refreshed current transfer notes, request ledger, current state and release plan for clean handoff into a new chat
- Home Assistant bridge contract remains unchanged

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
