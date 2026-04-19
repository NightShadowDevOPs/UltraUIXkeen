# UI Mihomo / Ultra — release plan

## Current release line
- **v1.2.136** — HA snapshot runtime + short cache ✅
- **v1.2.137** — live-router validation + HA template package
- **v1.2.138** — optional MQTT/discovery spike (only if REST-first v1 stays clean)

## Current packaged artifacts
- Latest packaged release: **v1.2.136** (`UltraUIXkeen-v1.2.136.zip`)
- Latest chat-transfer pack: **v1.2.136** (`UltraUIXkeen-chat-transfer-v1.2.136.zip`)
- Latest HA handoff pack: **v1.2.136** (`UltraUIXkeen-ha-handoff-v1.2.136.zip`)

## Release status snapshot
- **v1.2.130** — fixed the broken backup-history template in `AgentCard.vue`; production build recovered.
- **v1.2.131** — stabilized the router network workspace and cleaned the agent version badge logic.
- **v1.2.132** — polished the traffic workspace with summary cards and clearer focus handling.
- **v1.2.133** — added traffic action shortcuts for quicker drill-down between users/devices/QoS profile contexts.
- **v1.2.134** — packaged the dedicated HA handoff docs for the neighboring SmartLife / Home Assistant project.
- **v1.2.135** — made the users/QoS traffic control strips sticky during long scroll sessions and synced the HA docs to the confirmed REST-first contract.
- **v1.2.136** — shipped the first router-agent HA snapshot runtime: new `ha_*` commands, lightweight on-router cache, synced handoff docs and example JSON payloads.

## Next step details
### v1.2.137 — live-router validation + HA template package
- validate the new `ha_contract_meta / ha_status / ha_traffic / ha_users / ha_qos` endpoints on a real XKeen router, not only in the build container
- prepare the HA-side template package: REST sensors / binary_sensors, attribute mapping and a small dashboard example against the current `zash.ha.snapshot.v1` contract
- confirm that `format_version=1` stays stable and avoid schema churn unless a real router test proves we missed something important

### v1.2.138 — optional MQTT/discovery spike
- only if needed, prototype MQTT publication as an additional contour over the already working REST payloads
- keep REST-first as the baseline; MQTT discovery must not become a blocker for the operational dashboard path
- keep the HA export namespace isolated from proxy-provider SSL checks and from heavy Mihomo config-management flows

## Hard constraints
- do not break automatic proxy-provider SSL certificate checks
- do not reintroduce heavy Mihomo config-management work into the hot path
- HA polling must keep reading short cached payloads rather than forcing repeated heavy shell rebuilds
- if config editing returns later, it must keep a working fallback reference config
