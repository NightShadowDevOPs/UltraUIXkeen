# Home Assistant entity map

## Зафиксированный first-stage namespace
- `sensor.smartlife_router_*`
- `binary_sensor.smartlife_router_*`

## Отдельные `sensor`
### Из `ha_status`
- `sensor.smartlife_router_cpu_pct`
- `sensor.smartlife_router_memory_used_mb`
- `sensor.smartlife_router_memory_pct`
- `sensor.smartlife_router_uptime_seconds`
- `sensor.smartlife_router_active_users_count`
- `sensor.smartlife_router_active_devices_count`
- `sensor.smartlife_router_limited_users_count`
- `sensor.smartlife_router_blocked_users_count`
- `sensor.smartlife_router_qos_enabled_count`

### Из `ha_traffic`
- `sensor.smartlife_router_wan_rx_bps`
- `sensor.smartlife_router_wan_tx_bps`
- `sensor.smartlife_router_total_rx_bytes`
- `sensor.smartlife_router_total_tx_bytes`

## Отдельные `binary_sensor`
### Из `ha_status`
- `binary_sensor.smartlife_router_wan_up`
- `binary_sensor.smartlife_router_agent_up`
- `binary_sensor.smartlife_router_mihomo_running`

### Из `ha_qos`
- `binary_sensor.smartlife_router_qos_enabled`

## Что отдаём атрибутами, а не отдельными сущностями
- `top_users`
- `top_devices`
- список `limited`
- список `blocked`
- `qos_rules_detail`
- `per_user_breakdown`
- `per_device_breakdown`
- `interface_detail`

## Рекомендованная частота обновления
- `ha_status` — **30 сек**
- `ha_traffic` — **15 сек**
- `ha_users` — **60 сек**
- `ha_qos` — **60 сек**

## История / графики
- минутные точки на роутере для первого этапа **не обязательны**;
- достаточно current rate + cumulative counters;
- историческую аналитику и графики накапливает сам Home Assistant;
- опциональный `60m` rollup можно держать позже, но не как блокирующее требование.

## Практический вывод
Для первого этапа не нужно плодить десятки динамических сущностей по каждому пользователю/устройству. В HA должны жить ключевые operational sensors, а деталь — ехать атрибутами и отдельными markdown/table карточками.
