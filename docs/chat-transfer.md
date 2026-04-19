# UI Mihomo / Ultra — перенос в новый чат

## Текущее состояние
- Текущая версия UI: **v1.2.136**
- Router-agent: **0.6.27**
- Основной репозиторий: `NightShadowDevOPs/UltraUIXkeen`
- Локальная папка: `Y:\Мой диск\Git\UltraUIXkeen`
- Путь на роутере: `/opt/UltraUIXkeen`

## Что вошло в v1.2.136
- поднят UI до `1.2.136`
- поднят `router-agent` до `0.6.27`
- в `api.sh` добавлены новые команды HA export-контура: `ha_contract_meta`, `ha_status`, `ha_traffic`, `ha_users`, `ha_qos`
- добавлен короткий cache-слой для snapshot-ответов Home Assistant, чтобы роутер не пересобирал тяжёлые shell-данные на каждый опрос: `30s / 15s / 60s / 60s`
- сброс внутреннего status/cache контура теперь заодно чистит и HA snapshot cache
- обновлены `CHANGELOG.md`, `docs/release-plan.md`, `CURRENT_CHAT_TRANSFER_NOTE.md`, `TRANSFER_CHAT` и этот файл
- обновлён HA handoff-пакет: `docs/ha-export-bridge.md`, `docs/ha-export/README.md`, `docs/ha-export/rest-contract.md`, `docs/ha-export/homeassistant-entity-map.md` и sample/example JSON

## Что проверять после выкладки
1. в UI версия показывает `v1.2.136`
2. на роутере `router-agent` отвечает командой:
   - `http://<router-ip>:9099/cgi-bin/api.sh?cmd=ha_contract_meta`
   - `http://<router-ip>:9099/cgi-bin/api.sh?cmd=ha_status`
   - `http://<router-ip>:9099/cgi-bin/api.sh?cmd=ha_traffic`
   - `http://<router-ip>:9099/cgi-bin/api.sh?cmd=ha_users`
   - `http://<router-ip>:9099/cgi-bin/api.sh?cmd=ha_qos`
3. ответы приходят JSON-ом с `format_version: 1`, а не HTML/ошибкой CGI
4. повторные вызовы не жарят роутер: трафик/пользователи/qoS читаются из короткого cache, а не пересобираются каждый раз в лоб
5. в архиве есть `docs/chat-transfer.md`, `CURRENT_CHAT_TRANSFER_NOTE.md` и обновлённая папка `docs/ha-export/`

## Следующий зафиксированный шаг
- **v1.2.137** — live-router validation + HA template package
- затем **v1.2.138** — optional MQTT/discovery spike, только если REST-first контур останется чистым и достаточно стабильным
