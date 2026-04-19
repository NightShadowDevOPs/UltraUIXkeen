# REST contract — first stage

## Endpoint set
Первый этап фиксирует 4 endpoint'а через лёгкий export-контур router-agent:
- `GET /cgi-bin/api.sh?cmd=ha_status`
- `GET /cgi-bin/api.sh?cmd=ha_traffic`
- `GET /cgi-bin/api.sh?cmd=ha_users`
- `GET /cgi-bin/api.sh?cmd=ha_qos`

## Общие правила
- ответы — JSON;
- в каждом ответе есть `format_version` и `timestamp`;
- Home Assistant не должен зависеть от UI HTML/DOM;
- ответы должны отдаваться из snapshot/cache, а не пересобираться тяжёлыми shell-командами на каждый запрос.

## Cache / refresh targets
- `ha_status` — TTL около **30 сек**;
- `ha_traffic` — TTL около **15 сек**;
- `ha_users` — TTL около **60 сек**;
- `ha_qos` — TTL около **60 сек**.

## Payload expectations
### `ha_status`
Должен содержать summary/system state:
- router identity;
- agent state/version;
- mihomo state/version;
- cpu/memory/uptime;
- wan up/down;
- active users/devices;
- limited/blocked/qos counts.

### `ha_traffic`
Должен содержать:
- current WAN RX/TX rates;
- cumulative RX/TX totals;
- interface detail атрибутами;
- optional minute rollup — только как later-stage enhancement.

### `ha_users`
Должен содержать:
- counts;
- `top_users`;
- `top_devices`;
- detail списки active/limited/blocked;
- per-user / per-device breakdown атрибутами.

### `ha_qos`
Должен содержать:
- `qos_enabled`;
- count/summary по правилам;
- qos rules detail атрибутами;
- impacted users/devices/hosts summary.

## HA entity namespace
- `sensor.smartlife_router_*`
- `binary_sensor.smartlife_router_*`

Полный список ключевых entities вынесен в `homeassistant-entity-map.md`.
