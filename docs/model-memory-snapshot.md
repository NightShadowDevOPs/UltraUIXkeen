# Model memory snapshot — UI Mihomo / Ultra

## Working context
- Date: **2026-04-20**
- UI version: **v1.2.157**
- router-agent version: **0.6.32**

## What changed most recently
- `v1.2.149`: UI-side duplicate reads for `traffic_live`, `host_traffic_live` and `lan_hosts` are now deduped/cached briefly; Overview/Traffic charts reuse the last stable live sample on short telemetry misses instead of dropping to zero
- `v1.2.150`: Host QoS / Users QoS secondary polling loops are thinned out; repeated `status`, `qos_status` and `lan_hosts` reads are cached briefly inside the widget flow so the router sees fewer redundant reads
- `v1.2.151`: Host QoS / Users QoS secondary cards pause background polling while off-screen and softly refresh when they become visible again
- `v1.2.152`: Router Resources / Router agent cards use the same off-screen pause pattern so host-status polling no longer spins invisibly
- `v1.2.153`: Overview router health card pauses its background `/version` probe while off-screen and softly refreshes when visible again
- `v1.2.154`: Overview traffic card pauses secondary host-detail polling while the card is off-screen; the main live traffic contour stays untouched
- `v1.2.155`: Overview traffic card now also slows its main live polling cadence while off-screen, but returns to immediate full-speed refresh when the card becomes visible again
- `v1.2.156`: traffic weight collection and batch latency tests were softened without changing the router-agent contract
- `v1.2.157`: stale proxy-provider panel entries can now be deleted from Tasks UI, one by one or in bulk, when they remain only in saved settings

## Important constraints
- traffic through the router must not degrade because of UI work
- Overview traffic weights chart must keep working normally
- provider SSL checks are off-limits unless explicitly requested
- updater flow on the router remains the built-in UI updater

## Immediate next check
- verify real-router behavior after `v1.2.157`:
  1. saved-only / disabled provider rows are removed correctly
  2. active provider panel links still open correctly
  3. SSL dates and warnings still render for active providers
  4. Overview traffic weights chart and live runtime stay normal
