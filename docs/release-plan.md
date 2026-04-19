# Release plan — UI Mihomo / Ultra

## Release chain
- **v1.2.148** — Router-safe traffic telemetry hotfix: added short TTL cache in router-agent for live traffic/QoS/LAN payloads, limited heavy live reads in Host QoS card, preserved Overview traffic-weight diagram ✅
- **v1.2.149** — Traffic follow-up: validate weight diagram on real router load, review remaining heavy polling points, and polish Traffic workspace without hurting forwarding/QoS runtime
- **v1.2.150** — QoS/shaping transparency: clearer runtime diagnostics for shaped hosts, downlink/uplink class visibility, cleaner operator UX
- **later** — broader menu/IA cleanup and Mihomo config workspace separation, without touching stable SSL/provider checks unless explicitly requested

## Packaging baseline
- Latest packaged release: **v1.2.148** (`UltraUIXkeen-v1.2.148.zip`)
- Latest chat-transfer pack: **v1.2.148** (`UltraUIXkeen-chat-transfer-v1.2.148.zip`)
- Latest HA handoff pack: **v1.2.148** (`UltraUIXkeen-ha-handoff-v1.2.148.zip`)
- Latest router-agent line: **0.6.32**

## What shipped in v1.2.148
- UI raised to **1.2.148**
- Router-agent raised to **0.6.32**
- Added tiny server-side cache windows for:
  - `traffic_live`
  - `host_traffic_live`
  - `qos_status`
  - `lan_hosts`
- Changed Host QoS card startup path: summary data loads first, live per-host traffic loads only when really needed
- Synced docs and HA handoff examples to the new agent line

## Operator notes
- Release intent is defensive: reduce telemetry pressure on the router, not add more pretty-but-expensive polling.
- Keep watching whether the Overview traffic-weight chart receives normal data under real load.
- If new UI widgets need frequent traffic polling, prefer reuse of cached payloads or explicit on-demand loading.
