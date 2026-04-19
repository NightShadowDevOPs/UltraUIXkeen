# Home Assistant entity map

## Минимальный набор сущностей
### Из `ha_status`
- sensor.router_cpu_pct
- sensor.router_memory_used_mb
- sensor.router_active_users
- sensor.router_active_devices
- sensor.router_rx_rate
- sensor.router_tx_rate
- binary_sensor.router_wan_up
- binary_sensor.router_mihomo_running

### Из `ha_traffic`
- sensor.router_total_rx_bytes
- sensor.router_total_tx_bytes
- отдельная карточка/график по `rollup.samples`

### Из `ha_users`
- sensor.router_users_active
- sensor.router_users_limited
- sensor.router_users_blocked
- sensor.router_users_without_devices

### Из `ha_qos`
- sensor.router_qos_normal
- sensor.router_qos_limited
- sensor.router_qos_blocked

## Рекомендации для HA
- не опрашивать summary чаще, чем раз в 30 секунд;
- traffic rollup допустимо читать раз в 15–30 секунд;
- длинные списки пользователей/устройств лучше показывать отдельной таблицей, а не плодить сотни сущностей;
- для первых релизов лучше стартовать с REST, а MQTT оставить как следующий этап.
