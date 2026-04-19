# UI Mihomo / Ultra — перенос в новый чат

## Текущее состояние
- Текущая версия UI: **v1.2.136**
- Router-agent: **0.6.27**
- Основной репозиторий: `NightShadowDevOPs/UltraUIXkeen`
- Локальная папка: `Y:\Мой диск\Git\UltraUIXkeen`
- Путь на роутере: `/opt/UltraUIXkeen`

## Что сделано в v1.2.136
- добавлен первый runtime-контур HA snapshot export на стороне router-agent
- появились команды `ha_contract_meta`, `ha_status`, `ha_traffic`, `ha_users`, `ha_qos`
- добавлен короткий cache для HA-ответов (`30s / 15s / 60s / 60s`), чтобы не молотить shell без толку
- обновлены handoff docs и example JSON для соседнего SmartLife / Home Assistant проекта
- `router-agent` поднят до `0.6.27`

## Что проверять после выкладки
1. версии UI / agent синхронизированы: `v1.2.136` и `0.6.27`
2. новые `ha_*` команды отвечают JSON-ом
3. handoff-архив для HA содержит `ha_contract_meta` и обновлённые sample/example payloads
4. в кодовом архиве есть актуальный `docs/chat-transfer.md`

## Следующий зафиксированный шаг
- **v1.2.137** — live-router validation + HA template package
- затем **v1.2.138** — optional MQTT/discovery spike
