# CURRENT CHAT TRANSFER NOTE

## Current state
- Текущая версия UI: **v1.2.137**
- Router-agent: **0.6.28**
- Проект: **UI Mihomo / Ultra** (`NightShadowDevOPs/UltraUIXkeen`)
- Локальная папка: `Y:\Мой диск\Git\UltraUIXkeen`
- Путь на роутере: `/opt/UltraUIXkeen`

## Что сделано в v1.2.137
- поднят UI до `1.2.137`
- поднят `router-agent` до `0.6.28`
- добавлен готовый пакет Home Assistant в `docs/ha-export/homeassistant/`
- добавлены готовые YAML-файлы: конфигурационный snippet, REST sensors/binary sensors, template helpers и пример Lovelace dashboard
- исправлена синхронизация `serverVersion` в agent status/HA status после обновления агента
- обновлены `CHANGELOG.md`, `docs/release-plan.md`, `docs/chat-transfer.md`, `TRANSFER_CHAT` и HA handoff docs

## Важное по live-проверке
- команды `ha_contract_meta` и `status` на роутере уже отвечают по `http://192.168.0.1:9099/cgi-bin/api.sh?...`
- для live-проверок на этом стенде лучше использовать `192.168.0.1`, а не `127.0.0.1`
- до фикса `v1.2.137` на живом роутере наблюдался хвост: `status.version=0.6.27`, но `serverVersion=0.5.57`; в этом релизе синхронизация версии прибита явно

## Следующий шаг
- проверить на роутере обновлённый agent `0.6.28`
- затем можно идти либо в UI-потребление HA payloads, либо в расширение snapshot-диагностики/карточек под Home Assistant
