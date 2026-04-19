# Model memory snapshot — UI Mihomo / Ultra

## Working context
- Date: **2026-04-20**
- UI version: **v1.2.151**
- router-agent version: **0.6.32**

## What changed most recently
- `v1.2.148`: heavy telemetry endpoints on router-agent (`traffic_live`, `host_traffic_live`, `qos_status`, `lan_hosts`) moved behind short TTL cache; Host QoS live refresh became more demand-driven
- `v1.2.149`: UI-side duplicate reads for `traffic_live`, `host_traffic_live` and `lan_hosts` are now deduped/cached briefly; Overview/Traffic charts reuse the last stable live sample on short telemetry misses instead of dropping to zero
- `v1.2.150`: Host QoS / Users QoS secondary polling loops are thinned out; repeated `status`, `qos_status` and `lan_hosts` reads are cached briefly inside the widget flow so the router sees fewer redundant reads
- `v1.2.151`: Host QoS / Users QoS secondary cards pause background polling while off-screen and softly refresh when they become visible again

## Important constraints
- traffic through the router must not degrade because of UI work
- Overview traffic weights chart must keep working normally
- provider SSL checks are off-limits unless explicitly requested
- updater flow on the router remains the built-in UI updater

## Immediate next check
- verify real-router behavior after `v1.2.151`:
  1. Overview traffic weights chart updates normally
  2. off-screen QoS cards really stop background refresh and resume cleanly
  3. router throughput/latency does not regress
