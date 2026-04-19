# UI Mihomo / Ultra — release plan

## Current release line
- **v1.2.135** — sticky traffic workbench + HA contract sync ✅
- **v1.2.136** — lightweight router-agent export groundwork
- **v1.2.137** — first router-agent snapshot endpoints for Home Assistant

## Current packaged artifacts
- Latest packaged release: **v1.2.135** (`UltraUIXkeen-v1.2.135.zip`)
- Latest chat-transfer pack: **v1.2.135** (`UltraUIXkeen-chat-transfer-v1.2.135.zip`)
- Latest HA handoff pack: **v1.2.135** (`UltraUIXkeen-ha-handoff-v1.2.135.zip`)

## Release status snapshot
- **v1.2.130** — fixed the broken backup-history template in `AgentCard.vue`; production build recovered.
- **v1.2.131** — stabilized the router network workspace and cleaned the agent version badge logic.
- **v1.2.132** — polished the traffic workspace with summary cards and clearer focus handling.
- **v1.2.133** — added traffic action shortcuts for quicker drill-down between users/devices/QoS profile contexts.
- **v1.2.134** — packaged the dedicated HA handoff docs for the neighboring SmartLife / Home Assistant project.
- **v1.2.135** — made the users/QoS traffic control strips sticky during long scroll sessions and synced the HA docs to the confirmed REST-first contract.

## Next step details
### v1.2.136 — lightweight router-agent export groundwork
- formalize the JSON schema and `format_version` policy for `ha_status`, `ha_traffic`, `ha_users`, `ha_qos`
- define snapshot/cache keys and safe TTL rules (`15s / 30s / 60s / 60s`)
- prepare the router-agent-side data builder so HA reads lightweight cached payloads, not raw heavy shell flows

### v1.2.137 — first router-agent snapshot endpoints
- expose the first lightweight REST endpoints for `ha_status` and `ha_traffic`
- keep the first runtime stage REST-only; MQTT/discovery stay out of scope for now
- do not touch proxy-provider SSL checks while adding the new export namespace

## Hard constraints
- do not break automatic proxy-provider SSL certificate checks
- do not reintroduce heavy Mihomo config-management work into the hot path
- if config editing returns later, it must keep a working fallback reference config
