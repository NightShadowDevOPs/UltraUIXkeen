# Request ledger — UI Mihomo / Ultra

## 2026-04-20
- User request: continue after `v1.2.148` and keep reducing router-side pressure without harming real traffic.
- User constraint: traffic through the router must not suffer.
- User constraint: the Overview diagram with traffic weights must keep working normally.
- Action in `v1.2.149`: added UI-side short-lived dedupe/cache for `traffic_live`, `host_traffic_live` and `lan_hosts` requests.
- Action in `v1.2.149`: added fallback to the last stable live telemetry sample for Overview/Traffic graphs and host live stats so brief agent misses do not zero charts.
- Follow-up request to keep in scope: keep looking at what can be taken safely from upstream, but only if it does not increase background load or endanger runtime traffic.
