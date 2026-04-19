# UI Mihomo / Ultra — перенос в новый чат

## Текущее состояние
- Текущая версия UI: **v1.2.135**
- Router-agent: **0.6.26**
- Основной репозиторий: `NightShadowDevOPs/UltraUIXkeen`
- Локальная папка: `Y:\Мой диск\Git\UltraUIXkeen`
- Путь на роутере: `/opt/UltraUIXkeen`

## Что сделано в v1.2.135
- в `Router → Трафик → Пользователи` сделана sticky-панель рабочего контура: поиск, focus, счётчики и bulk-операции остаются видимыми при длинной прокрутке
- в `Router → Трафик → Хосты / QoS` сделана sticky-сводка с поиском, текущим focus и краткими счётчиками, чтобы не приходилось каждый раз возвращаться вверх
- обновлён handoff-пакет для интеграции роутера с Home Assistant: зафиксирован подтверждённый REST-first контракт, namespace сущностей `smartlife_router_*`, интервалы обновления и разделение sensor/binary_sensor vs attributes
- `router-agent` в этом релизе не менялся и остаётся `0.6.26`

## Что проверять после выкладки
1. `Router → Трафик → Пользователи`: при длинной прокрутке sticky-панель остаётся видимой, фильтр и bulk-операции работают
2. `Router → Трафик → Пользователи`: выбор нескольких пользователей, apply profile, unblock/reset и disable limits не сломаны
3. `Router → Трафик → Хосты / QoS`: sticky-сводка остаётся сверху и не перекрывает таблицу/строки
4. в архиве есть `docs/ha-export-bridge.md` и папка `docs/ha-export/` с обновлённым confirmed-contract для HA
5. `CURRENT_CHAT_TRANSFER_NOTE.md` и `docs/chat-transfer.md` синхронизированы по версии `v1.2.135`

## Следующий зафиксированный шаг
- **v1.2.136** — lightweight router-agent export groundwork: формализовать payload schema/version и cache/TTL для `ha_status / ha_traffic / ha_users / ha_qos`
- затем **v1.2.137** — первый runtime-этап snapshot endpoint'ов на стороне router-agent без MQTT/discovery в первом шаге
