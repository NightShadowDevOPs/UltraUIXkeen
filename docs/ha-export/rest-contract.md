# REST contract — runtime v1

## Endpoint set
Текущий runtime-этап фиксирует 5 endpoint'ов через лёгкий export-контур router-agent:
- `GET /cgi-bin/api.sh?cmd=ha_contract_meta`
- `GET /cgi-bin/api.sh?cmd=ha_status`
- `GET /cgi-bin/api.sh?cmd=ha_traffic`
- `GET /cgi-bin/api.sh?cmd=ha_users`
- `GET /cgi-bin/api.sh?cmd=ha_qos`

## Общие правила
- ответы — JSON;
- у snapshot payloads есть `format_version` и `timestamp`;
- контракт идентифицируется через `ha_contract_meta` как `zash.ha.snapshot.v1`;
- Home Assistant не должен зависеть от UI HTML/DOM;
- ответы должны отдаваться из snapshot/cache, а не пересобираться тяжёлыми shell-командами на каждый запрос;
- текущий runtime использует короткий on-router cache.

## Cache / refresh targets
- `ha_status` — TTL **30 сек**;
- `ha_traffic` — TTL **15 сек**;
- `ha_users` — TTL **60 сек**;
- `ha_qos` — TTL **60 сек**.

## Payload schemas
### `ha_contract_meta`
```json
{
  "ok": true,
  "format_version": 1,
  "timestamp": "2026-04-19T13:16:21Z",
  "contract": "zash.ha.snapshot.v1",
  "agent_version": "0.6.27",
  "cache": {
    "ha_status_ttl_sec": 30,
    "ha_traffic_ttl_sec": 15,
    "ha_users_ttl_sec": 60,
    "ha_qos_ttl_sec": 60
  },
  "commands": ["ha_contract_meta", "ha_status", "ha_traffic", "ha_users", "ha_qos"],
  "entity_namespace": {
    "sensor": "sensor.smartlife_router_*",
    "binary_sensor": "binary_sensor.smartlife_router_*"
  },
  "notes": {
    "transport": "json over router-agent cgi",
    "snapshot_cache": "short on-router cache to avoid rebuilding shell snapshots on every poll"
  }
}
```

### `ha_status`
Должен содержать:
- `router.hostname / model / firmware`
- `agent.up / version / serverVersion`
- `mihomo.running / version`
- `system.cpu_pct / memory_used_mb / memory_pct / uptime_seconds / wan_up / wan_iface`
- `counts.active_users / active_devices / limited_users / blocked_users / qos_enabled`
- `capabilities.tc / iptables / hashlimit`

### `ha_traffic`
Должен содержать:
- `wan.iface / rx_bps / tx_bps / rx_bytes / tx_bytes`
- `summary.wan_rx_bps / wan_tx_bps / total_rx_bytes / total_tx_bytes`
- `interface_detail[]` со структурой:
  - `name`
  - `kind`
  - `rx_bytes`
  - `tx_bytes`
  - `rx_bps`
  - `tx_bps`

### `ha_users`
Должен содержать:
- `counts.active_users / active_devices / limited_users / blocked_users`
- `top_users[]` со структурой `name / rx_bps / tx_bps`
- `top_devices[]` со структурой `name / mac / rx_bps / tx_bps / ip`
- `limited[]` со структурой `name / source / profile / target`
- `blocked[]` со структурой `name / reason / target`
- `per_user_breakdown[]` — тот же формат, что и `top_users[]`
- `per_device_breakdown[]` — тот же формат, что и `top_devices[]`

### `ha_qos`
Должен содержать:
- `qos_enabled` boolean
- `counts.qos_enabled / limited_users / blocked_users`
- `summary.wan_rate_mbit / lan_rate_mbit / rules_active / shaper_downlink_mode`
- `qos_rules_detail[]` со структурой `target / profile / shape / detail`

## HA entity namespace
- `sensor.smartlife_router_*`
- `binary_sensor.smartlife_router_*`

Полный список ключевых entities вынесен в `homeassistant-entity-map.md`.

## Compatibility note
Если соседний проект увидит новый `contract` или `format_version`, сначала надо переключать маппинг на основании `ha_contract_meta`, а не угадывать схему по полям на лету.
