# Request ledger — UI Mihomo / Ultra

## 2026-04-20
- User request: continue after `v1.2.148` and keep reducing router-side pressure without harming real traffic.
- User constraint: traffic through the router must not suffer.
- User constraint: the Overview diagram with traffic weights must keep working normally.
- Action in `v1.2.149`: added UI-side short-lived dedupe/cache for `traffic_live`, `host_traffic_live` and `lan_hosts` requests.
- Action in `v1.2.149`: added fallback to the last stable live telemetry sample for Overview/Traffic graphs and host live stats so brief agent misses do not zero charts.
- Action in `v1.2.150`: slowed down secondary Host QoS / Users QoS background refresh loops, while keeping the main live traffic contour intact.
- Action in `v1.2.150`: added brief cache windows for repeated `status`, `qos_status` and `lan_hosts` reads inside Traffic/QoS widget flows.
- Action in `v1.2.150`: silent background refresh in Host QoS no longer flips the loading state on every timer tick.
- Action in `v1.2.151`: made secondary Host QoS / Users QoS polling viewport-aware so invisible cards pause background refresh.
- Action in `v1.2.151`: when those cards become visible again, UI triggers a soft QoS/runtime refresh without changing the main traffic live contour.
- Follow-up request to keep in scope: keep looking at what can be taken safely from upstream, but only if it does not increase background load or endanger runtime traffic.
- Action in `v1.2.152`: extended the same viewport-aware lazy strategy to Router → Resources and Router agent cards so invisible host-status widgets pause background refresh.
- Action in `v1.2.152`: when those host-status cards return into view, UI triggers a soft runtime refresh without touching the main traffic live contour.
