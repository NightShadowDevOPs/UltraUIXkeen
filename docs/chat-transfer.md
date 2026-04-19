# UI Mihomo / Ultra — перенос в новый чат

## Текущее состояние
- Текущая версия UI: **v1.2.134**
- Router-agent: **0.6.26**
- Основной репозиторий: `NightShadowDevOPs/UltraUIXkeen`
- Локальная папка: `Y:\Мой диск\Git\UltraUIXkeen`
- Путь на роутере: `/opt/UltraUIXkeen`

## Что сделано в v1.2.134
- подготовлен отдельный handoff-пакет для интеграции роутера с Home Assistant
- зафиксирован архитектурный подход: Home Assistant получает данные через лёгкий экспортный контур `router-agent`, а не через парсинг UI
- оформлены базовые контракты для `ha_status / ha_traffic / ha_users / ha_qos`
- добавлены примерные JSON payload'ы и entity map для соседнего HA-проекта
- `router-agent` в этом релизе не менялся и остаётся `0.6.26`

## Что проверять после выкладки
1. в архиве проекта есть `docs/ha-export-bridge.md` и папка `docs/ha-export/`
2. в `docs/ha-export/` лежат example payload'ы для `status / traffic / users / qos`
3. `CURRENT_CHAT_TRANSFER_NOTE.md` и `docs/chat-transfer.md` синхронизированы по версии `v1.2.134`

## Следующий зафиксированный шаг
- **v1.2.135** — Router traffic sticky summary: проверить, нужен ли ещё компактный sticky-summary/action-bar для длинных списков
