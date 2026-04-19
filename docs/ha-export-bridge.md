# UI Mihomo / Ultra — HA export bridge

## Что уже сделано в v1.2.136
На стороне `router-agent` поднят первый runtime-контур для Home Assistant snapshot export.

Доступные команды:
- `cmd=ha_contract_meta`
- `cmd=ha_status`
- `cmd=ha_traffic`
- `cmd=ha_users`
- `cmd=ha_qos`

## Цель контура
Отдать данные с роутера в Home Assistant так, чтобы:
- не парсить HTML/UI;
- не грузить роутер тяжёлыми запросами;
- получить в HA operational dashboard по состоянию роутера, WAN, пользователям, устройствам, трафику и QoS;
- не ломать автопроверку SSL-сертификатов proxy-provider'ов.

## Зафиксированный транспорт
### Текущий runtime
- **REST — основной и обязательный транспорт**.
- Контракт первого runtime-этапа строится вокруг пяти команд:
  - `ha_contract_meta`
  - `ha_status`
  - `ha_traffic`
  - `ha_users`
  - `ha_qos`

### Следующий этап
- MQTT допускается как **дополнительный контур**, но не входит в текущий runtime scope.
- MQTT discovery на первом этапе **не нужен**.

## Базовый принцип
Home Assistant читает **отдельный лёгкий export-контур**, а не внутренние UI-представления и не тяжёлые shell-пайплайны напрямую.

Правильная схема:
1. `router-agent` собирает короткий snapshot;
2. snapshot кэшируется на роутере;
3. UI живёт своей жизнью;
4. Home Assistant читает уже готовые HA-friendly JSON endpoints.

## Почему это безопаснее для роутера
Если HA каждые 5–10 секунд вызывает тяжёлые shell-скрипты с полным разбором трафика и live-списков, роутер начнёт греться и тормозить.

Поэтому HA-контур сейчас работает так:
- короткие JSON-ответы;
- кэш 15–60 секунд;
- предагрегированные данные;
- без обязательной исторической аналитики на роутере.

## Текущий состав payloads
### 1. `ha_contract_meta`
Метаданные runtime-контракта:
- `contract = zash.ha.snapshot.v1`
- `format_version = 1`
- agent version
- TTL для каждого snapshot endpoint
- список поддерживаемых команд
- namespace для `sensor` и `binary_sensor`

### 2. `ha_status`
Operational summary / system state.

Содержимое:
- router identity;
- agent state/version;
- mihomo state/version;
- cpu/memory/uptime;
- wan up/down;
- active users/devices;
- limited/blocked/qos counts;
- capability flags (`tc`, `iptables`, `hashlimit`).

### 3. `ha_traffic`
Traffic rates + totals.

Содержимое:
- current WAN RX/TX rate;
- cumulative RX/TX counters;
- `interface_detail` массив с per-interface counters/rates.

### 4. `ha_users`
Counts + top lists + active/limited/blocked detail.

Содержимое:
- counts;
- `top_users`;
- `top_devices`;
- detail списки `limited` / `blocked`;
- `per_user_breakdown` / `per_device_breakdown` — атрибутами, а не россыпью отдельных HA сущностей.

### 5. `ha_qos`
Enabled flag + counts + краткая сводка правил.

Содержимое:
- `qos_enabled` flag;
- count/summary по ограничениям и блокировкам;
- `summary` с line-rate/rules_active/downlink mode;
- `qos_rules_detail` атрибутами.

## Зафиксированная частота обновления
- `ha_status` — **30 сек**
- `ha_traffic` — **15 сек**
- `ha_users` — **60 сек**
- `ha_qos` — **60 сек**

## Entity naming, согласованный с HA-проектом
- `sensor.smartlife_router_*`
- `binary_sensor.smartlife_router_*`

Префикс `smartlife_router_` обязателен, чтобы не было коллизий и чтобы контур был сразу читаемым в Home Assistant.

## Что идёт отдельными сущностями
### Sensors
- `sensor.smartlife_router_cpu_pct`
- `sensor.smartlife_router_memory_used_mb`
- `sensor.smartlife_router_memory_pct`
- `sensor.smartlife_router_uptime_seconds`
- `sensor.smartlife_router_active_users_count`
- `sensor.smartlife_router_active_devices_count`
- `sensor.smartlife_router_limited_users_count`
- `sensor.smartlife_router_blocked_users_count`
- `sensor.smartlife_router_qos_enabled_count`
- `sensor.smartlife_router_wan_rx_bps`
- `sensor.smartlife_router_wan_tx_bps`
- `sensor.smartlife_router_total_rx_bytes`
- `sensor.smartlife_router_total_tx_bytes`

### Binary sensors
- `binary_sensor.smartlife_router_wan_up`
- `binary_sensor.smartlife_router_agent_up`
- `binary_sensor.smartlife_router_mihomo_running`
- `binary_sensor.smartlife_router_qos_enabled`

## Что не надо раздувать в отдельные сущности
Атрибутами можно и нужно отдавать:
- `top_users`
- `top_devices`
- список `limited` / `blocked`
- `qos_rules_detail`
- `per_user_breakdown`
- `per_device_breakdown`
- `interface_detail`

## Минимальный smoke test
```sh
/opt/bin/wget -qO- "http://127.0.0.1:9099/cgi-bin/api.sh?cmd=ha_contract_meta"
/opt/bin/wget -qO- "http://127.0.0.1:9099/cgi-bin/api.sh?cmd=ha_status"
/opt/bin/wget -qO- "http://127.0.0.1:9099/cgi-bin/api.sh?cmd=ha_traffic"
/opt/bin/wget -qO- "http://127.0.0.1:9099/cgi-bin/api.sh?cmd=ha_users"
/opt/bin/wget -qO- "http://127.0.0.1:9099/cgi-bin/api.sh?cmd=ha_qos"
```

## Следующий технический шаг
- проверить контур на живом XKeen-роутере;
- собрать HA-side template package поверх текущего `zash.ha.snapshot.v1`;
- только потом решать, нужен ли второй транспортный слой вроде MQTT.
