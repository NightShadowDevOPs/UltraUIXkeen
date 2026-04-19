# Home Assistant entity map

## Core imported entities
- `sensor.smartlife_router_snapshot_timestamp`
- `sensor.smartlife_router_status_snapshot`
- `sensor.smartlife_router_traffic_snapshot`
- `sensor.smartlife_router_users_snapshot`
- `sensor.smartlife_router_qos_snapshot`
- `sensor.smartlife_router_qos_summary`

## Derived helper entities added in v1.2.142
- `sensor.smartlife_router_snapshot_age_sec`
- `sensor.smartlife_router_traffic_age_sec`
- `sensor.smartlife_router_users_age_sec`
- `sensor.smartlife_router_qos_age_sec`
- `sensor.smartlife_router_snapshot_freshness`
- `binary_sensor.smartlife_router_snapshot_stale`

## Existing summary / status entities used by the example dashboard
- `binary_sensor.smartlife_router_agent_up`
- `sensor.smartlife_router_agent_version`
- `sensor.smartlife_router_agent_server_version`
- `binary_sensor.smartlife_router_mihomo_running`
- `sensor.smartlife_router_cpu_pct`
- `sensor.smartlife_router_memory_pct`
- `sensor.smartlife_router_uptime_sec`
- `binary_sensor.smartlife_router_wan_up`
- `sensor.smartlife_router_wan_rx_mbps`
- `sensor.smartlife_router_wan_tx_mbps`
- `sensor.smartlife_router_wan_rx_bytes`
- `sensor.smartlife_router_wan_tx_bytes`
- `sensor.smartlife_router_total_rx_bytes`
- `sensor.smartlife_router_total_tx_bytes`
- `sensor.smartlife_router_active_users`
- `sensor.smartlife_router_active_devices`
- `sensor.smartlife_router_limited_users`
- `sensor.smartlife_router_blocked_users`
- `binary_sensor.smartlife_router_qos_enabled`
- `sensor.smartlife_router_qos_rules_active`
