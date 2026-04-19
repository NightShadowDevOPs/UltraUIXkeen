# HA export handoff

Начиная с **v1.2.136** router-agent уже умеет отдавать snapshot payloads для Home Assistant.
Начиная с **v1.2.137** сюда добавлен ещё и **готовый YAML bundle** для Home Assistant.

## Что лежит в этой папке
- `rest-contract.md` — описание JSON-контракта
- `homeassistant-entity-map.md` — карта имён sensor / binary_sensor
- `sample-ha-*.json` — sample payloads
- `*.example.json` — example payloads для handoff
- `homeassistant/` — готовые YAML-файлы для быстрого подключения в Home Assistant

## Основные команды router-agent
- `ha_contract_meta`
- `ha_snapshot` ← предпочтительный агрегированный endpoint для Home Assistant
- `ha_status`
- `ha_traffic`
- `ha_users`
- `ha_qos`

## Live-адрес текущего стенда
`http://192.168.0.1:9099/cgi-bin/api.sh`

## Contract stability
- В релизе `v1.2.141` структура JSON для Home Assistant намеренно не менялась.
- Текущий handoff baseline: `ha_snapshot` + `router-agent 0.6.31`.
- Следующие UI-релизы по возможности должны использовать уже существующие поля и timestamps, не ломая этот контракт без отдельной причины.

