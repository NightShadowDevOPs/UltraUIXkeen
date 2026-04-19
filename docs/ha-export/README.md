# HA export handoff

Этот пакет предназначен для соседнего проекта SmartLife / Home Assistant.

Внутри лежит **уже подтверждённый** контракт первого этапа для данных, которые нужно получить с роутера:
- `ha_status` — summary/system state;
- `ha_traffic` — rates + totals;
- `ha_users` — counts + top lists + active/limited/blocked detail;
- `ha_qos` — enabled flag + counts + краткая сводка правил.

## Что уже зафиксировано
- транспорт первого этапа: **REST-first**;
- MQTT оставлен как следующий дополнительный контур;
- MQTT discovery на первом этапе не нужен;
- историческую аналитику роутер не обязан хранить для первой версии;
- Home Assistant накапливает историю сам, поверх current rate + cumulative counters.

## Источник данных
Предполагаемая схема такая:
- роутер / `router-agent` готовит snapshot;
- snapshot кэшируется на роутере;
- Home Assistant читает готовые лёгкие JSON-ответы;
- UI и HA не парсят друг друга.

Главная мысль: **не дёргать тяжёлые shell-скрипты из HA на каждый запрос**.

## Что важно для соседнего проекта
- namespace сущностей: `sensor.smartlife_router_*`, `binary_sensor.smartlife_router_*`;
- ключевые operational значения должны жить отдельными entities;
- длинные списки и топы должны ехать атрибутами, а не десятками/сотнями dynamic entities;
- update cadence: `30s / 15s / 60s / 60s` для `status / traffic / users / qos`.

Детализация — в файлах `homeassistant-entity-map.md`, `rest-contract.md`, `sample-*.json`.
