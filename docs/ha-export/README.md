# HA export handoff

Этот пакет предназначен для соседнего проекта SmartLife / Home Assistant.

Начиная с **v1.2.136** здесь лежит уже не только blueprint, а **реальный runtime-контур** router-agent для Home Assistant snapshot export.

## Что есть в runtime
Через router-agent доступны команды:
- `ha_contract_meta` — метаданные контракта, TTL и namespace;
- `ha_status` — summary/system state;
- `ha_traffic` — rates + totals + interface detail;
- `ha_users` — counts + top lists + limited/blocked + per-user/device breakdown;
- `ha_qos` — enabled flag + counts + summary + qos rules detail.

## Что уже зафиксировано
- транспорт первого этапа: **REST-first**;
- `contract = zash.ha.snapshot.v1`;
- `format_version = 1`;
- MQTT оставлен как следующий дополнительный контур;
- MQTT discovery на первом этапе не нужен;
- историческую аналитику роутер не обязан хранить для первой версии;
- Home Assistant накапливает историю сам, поверх current rate + cumulative counters.

## Источник данных
Схема теперь такая:
1. `router-agent` собирает HA-friendly snapshot;
2. snapshot коротко кэшируется на роутере;
3. Home Assistant читает готовые лёгкие JSON-ответы;
4. UI и HA не парсят друг друга.

Главная мысль всё та же: **не дёргать тяжёлые shell-скрипты из HA на каждый запрос**.

## TTL / update cadence
- `ha_status` — **30 сек**
- `ha_traffic` — **15 сек**
- `ha_users` — **60 сек**
- `ha_qos` — **60 сек**

## Что важно для соседнего проекта
- namespace сущностей: `sensor.smartlife_router_*`, `binary_sensor.smartlife_router_*`;
- ключевые operational значения должны жить отдельными entities;
- длинные списки и топы должны ехать атрибутами, а не десятками/сотнями dynamic entities;
- для совместимости сначала проверять `ha_contract_meta`, а уже потом маппить payloads.

## Что лежит в пакете
- `README.md` — эта сводка;
- `rest-contract.md` — текущий runtime-контракт и поля payloads;
- `homeassistant-entity-map.md` — рекомендуемая раскладка сущностей;
- `sample-ha-*.json` — человекочитаемые sample payloads;
- `*.example.json` — те же примеры в виде handoff-файлов для импорта/копирования;
- `ha-export-bridge.md` — архитектурный мост между роутером и HA.
