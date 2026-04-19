# Changelog

## v1.2.136 — HA snapshot runtime + short cache
- raised UI to `1.2.136`
- raised `router-agent` to `0.6.27`
- added new router-agent commands for the Home Assistant export contour: `ha_contract_meta`, `ha_status`, `ha_traffic`, `ha_users`, `ha_qos`
- added a short on-router cache for HA snapshot payloads so repeated polling does not keep reheating shell flows: `30s / 15s / 60s / 60s` for `status / traffic / users / qos`
- wired HA cache cleanup into the normal lightweight cache reset path
- refreshed docs, changelog, release-plan, chat-transfer notes and the handoff pack for the neighboring SmartLife / Home Assistant project
- updated HA export examples so the docs now describe the real runtime payloads instead of only the pre-runtime contract

## v1.2.135 — sticky traffic workbench + HA contract sync
- made the traffic workspace and host QoS filter/action areas sticky, so the search, focus state, counts and bulk actions stay visible while scrolling through long lists
- kept the same bulk-limit and host filtering actions, but moved them into a more persistent control strip for faster operator work
- synced the Home Assistant handoff docs with the confirmed REST-first contract: entity names, update cadence, payload split and attribute strategy are now fixed in project docs
- router-agent is unchanged in this release and remains `0.6.26`

## v1.2.130 — AgentCard template closure hotfix
- fixed the missing closing container in `src/components/router/AgentCard.vue` unified backup history, which broke production build with `Element is missing end tag`
- kept the previously assembled backup workspace logic intact: archive inspection panel stays inside the correct list item scope
- router-agent is unchanged in this release and remains `0.6.26`

## v1.2.127 — backup workspace build hotfix
- fixed duplicate identifier in `src/components/router/AgentCard.vue` that broke production build for v1.2.126
- kept backup workspace loading logic and action flow intact, without touching proxy-provider SSL checks or router-agent behavior
- router-agent is unchanged in this release and remains `0.6.26`
