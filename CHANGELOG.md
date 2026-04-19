# Changelog

## v1.2.139 — aggregated HA snapshot bundle

- raised UI to `1.2.139`
- raised `router-agent` to `0.6.30`
- added aggregated `ha_snapshot` endpoint that returns one bundle with `status`, `traffic`, `users` and `qos`
- switched the default Home Assistant REST package to a single `ha_snapshot` resource to reduce parallel polling and stabilize router metrics in HA
- refreshed HA handoff docs, contract examples, release-plan and chat-transfer notes

## v1.2.138 — ha_status serverVersion sync hotfix

- raised `router-agent` to `0.6.29`
- fixed `ha_status` payload so `agent.serverVersion` is aligned with the installed agent runtime instead of stale cached metadata
- refreshed HA handoff YAML bundle and docs after live router verification

## v1.2.137 — HA package bundle + agent version sync
- raised UI to `1.2.137`
- raised `router-agent` to `0.6.28`
- fixed agent runtime status/version sync so `serverVersion` does not lag behind the installed agent after update
- added a ready-to-copy Home Assistant package bundle under `docs/ha-export/homeassistant/`
- added HA config snippet, REST package, template helpers and a sample Lovelace dashboard
- refreshed HA handoff docs, release-plan, chat-transfer docs and current transfer notes

## v1.2.136 — HA snapshot runtime + short cache
- raised UI to `1.2.136`
- raised `router-agent` to `0.6.27`
- added router-agent Home Assistant export commands: `ha_contract_meta`, `ha_status`, `ha_traffic`, `ha_users`, `ha_qos`
- added a short cache layer for HA snapshot payloads to avoid unnecessary load on the router
- updated release docs, chat-transfer docs and HA handoff JSON examples
