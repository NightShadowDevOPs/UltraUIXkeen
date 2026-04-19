# UI Mihomo / Ultra — HA export bridge blueprint

## Цель первого этапа
Нужно отдать данные с роутера в Home Assistant так, чтобы:
- не парсить HTML/UI;
- не грузить роутер тяжёлыми запросами;
- получить в HA operational dashboard по состоянию роутера, WAN, пользователям, устройствам, трафику и QoS;
- не ломать и не трогать автопроверку SSL-сертификатов прокси-провайдеров.

## Зафиксированный транспорт
### Первый этап
- **REST — основной и обязательный транспорт**.
- Контракт первого этапа строится вокруг четырёх лёгких endpoint'ов:
  - `cmd=ha_status`
  - `cmd=ha_traffic`
  - `cmd=ha_users`
  - `cmd=ha_qos`

### Следующий этап
- MQTT допускается как **дополнительный контур**, но не входит в первый runtime scope.
- MQTT discovery на первом этапе **не нужен**.

## Базовый принцип
Home Assistant читает **отдельный лёгкий export-контур**, а не внутренние UI-представления.

Правильная схема:
1. `router-agent` периодически собирает короткий snapshot;
2. snapshot кэшируется на роутере;
3. UI живёт своей жизнью;
4. Home Assistant читает уже готовые HA-friendly JSON endpoints.

## Почему не надо дёргать тяжёлые команды напрямую из HA
Если HA каждые 5–10 секунд вызывает shell-скрипты с полным разбором трафика, cloud-статусов и списков пользователей, роутер начнёт греться и тормозить.

Поэтому для HA нужны:
- короткие JSON-ответы;
- кэш 15–60 секунд;
- предагрегированные данные;
- без лишней детализации на каждый опрос.

## Зафиксированный состав endpoint'ов
### 1. `ha_status`
Operational summary / system state.

Содержимое:
- hostname/model/firmware;
- uptime;
- cpu/load/memory/storage;
- agent version;
- mihomo version / running;
- wan up/down;
- active users/devices;
- limited/blocked counts;
- qos enabled/count;
- timestamp snapshot.

### 2. `ha_traffic`
Traffic rates + totals.

Содержимое:
- current WAN RX/TX rate;
- cumulative RX/TX counters;
- interface detail в атрибутах;
- при необходимости later-stage optional rollup, но без обязательной исторической нагрузки на роутер.

### 3. `ha_users`
Counts + top lists + active/limited/blocked detail.

Содержимое:
- active user count;
- active device count;
- limited/blocked counts;
- `top_users`;
- `top_devices`;
- detail списки `limited` / `blocked`;
- per-user / per-device breakdown — атрибутами, а не россыпью отдельных HA сущностей.

### 4. `ha_qos`
Enabled flag + counts + краткая сводка правил.

Содержимое:
- qos enabled flag;
- qos enabled count;
- краткая сводка правил;
- qos rules detail атрибутами;
- summary по impacted users/devices/hosts.

## Зафиксированная частота обновления
- `ha_status` — **30 сек**
- `ha_traffic` — **15 сек**
- `ha_users` — **60 сек**
- `ha_qos` — **60 сек**

Это даёт нормальную operational-картину без перегрева роутера.

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
- список limited / blocked
- qos rules detail
- per-user / per-device breakdown
- interface detail

## История / аналитика
На текущем этапе нужен **operational dashboard**, а не тяжёлая историческая аналитика на стороне роутера.

То есть:
- текущее состояние роутера;
- WAN;
- активные пользователи / устройства;
- текущий трафик;
- QoS / limited / blocked.

Историческая аналитика — вторым этапом, уже поверх накопленной истории в Home Assistant.

## Нагрузка на роутер
При корректной реализации нагрузка будет умеренной.

Ключевое правило: **HA читает snapshot/cache, а не заставляет роутер каждый раз пересобирать всё с нуля**.

### Условно безопасно
- summary и counters;
- топы за интервал;
- короткие агрегаты;
- обновление не чаще 15 секунд.

### Потенциально тяжело
- полные live-списки каждую секунду;
- множественные shell-вызовы на каждый endpoint;
- глубокая детализация по каждому хосту в real time;
- попытка тащить исторические минутные точки прямо с роутера как обязательный контур.

## Минимальные технические требования к реализации
- один внутренний snapshot-builder;
- кэш на 15 сек для `ha_traffic`;
- кэш на 30–60 сек для `ha_status`, `ha_users`, `ha_qos`;
- стабильный `format_version` в JSON;
- без зависимости HA от UI-компонентов;
- без вмешательства в SSL provider checks;
- отдельный namespace для `ha_*` endpoints.

## Следующий технический шаг
Следующим релизом на стороне этого проекта нужно подготовить router-agent groundwork:
- формализовать payload schema/version;
- определить cache keys/TTL;
- подготовить безопасную сборку snapshot без тяжёлых повторных shell-вызовов;
- только потом переходить к первому runtime implementation release.
