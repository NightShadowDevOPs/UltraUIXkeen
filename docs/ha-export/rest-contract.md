# REST contract for Home Assistant snapshot export

## Base URL
`http://192.168.0.1:9099/cgi-bin/api.sh`

## Commands
- `cmd=ha_contract_meta`
- `cmd=ha_snapshot` ← предпочтительный агрегированный endpoint для Home Assistant
- `cmd=ha_status`
- `cmd=ha_traffic`
- `cmd=ha_users`
- `cmd=ha_qos`

## Contract meta
```json
{
  "ok": true,
  "format_version": 1,
  "timestamp": "2026-04-19T13:16:21Z",
  "contract": "zash.ha.snapshot.v1",
  "agent_version": "0.6.30",
  "preferred_resource": "ha_snapshot"
}
```

## Aggregated snapshot (`cmd=ha_snapshot`)
Один JSON-ответ, внутри которого уже лежат `status`, `traffic`, `users`, `qos`. Это снижает количество параллельных REST-запросов из Home Assistant и помогает убрать периодические `Нет данных` / `Empty reply when expecting JSON`.

## Status snapshot
Ключевые поля:
- `router.hostname / model / firmware`
- `agent.up / version / serverVersion`
- `mihomo.running / version`
- `system.cpu_pct / memory_used_mb / memory_pct / uptime_seconds / wan_up / wan_iface`
- `counts.active_users / active_devices / limited_users / blocked_users / qos_enabled`
- `capabilities.tc / iptables / hashlimit`

## Traffic snapshot
Ключевые поля:
- `summary.wan_rx_bps / wan_tx_bps / total_rx_bytes / total_tx_bytes`
- `interface_detail[]`

## Users snapshot
Ключевые поля:
- `counts.*`
- `top_users[]`
- `top_devices[]`
- `limited[]`
- `blocked[]`
- `per_user_breakdown[]`
- `per_device_breakdown[]`

## QoS snapshot
Ключевые поля:
- `qos_enabled`
- `counts.*`
- `summary.*`
- `qos_rules_detail[]`

## Home Assistant bundle
Готовые YAML-файлы лежат в `docs/ha-export/homeassistant/`. Начиная с `v1.2.139`, основной пакет переведён на единый `ha_snapshot` resource.
