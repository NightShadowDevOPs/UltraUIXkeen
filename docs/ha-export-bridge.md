# HA export bridge

## Что уже сделано

### v1.2.137
- добавлен готовый пакет файлов для Home Assistant в `docs/ha-export/homeassistant/`
- добавлены готовые YAML-примеры для `packages`, REST sensors/binary sensors, template helpers и Lovelace dashboard
- устранён хвост с рассинхроном `serverVersion` после обновления router-agent

### v1.2.136
- добавлены новые команды router-agent: `ha_contract_meta`, `ha_status`, `ha_traffic`, `ha_users`, `ha_qos`
- добавлен короткий cache-слой для HA snapshot-ответов
- обновлены docs и sample JSON

## Текущий контракт
- транспорт: HTTP/JSON через `router-agent` (`9099/cgi-bin/api.sh`)
- основной live-адрес для этого стенда: `http://192.168.0.1:9099/cgi-bin/api.sh`
- базовые команды: `status`, `ha_contract_meta`, `ha_status`, `ha_traffic`, `ha_users`, `ha_qos`

## Что теперь есть в handoff-пакете
- примеры JSON payloads
- карта entity names для Home Assistant
- описание REST-контракта
- готовые YAML-пакеты для Home Assistant
