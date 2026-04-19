# UltraUIXkeen — current chat transfer note

## Current release
- Текущая версия UI: **v1.2.142**
- Текущая версия `router-agent`: **0.6.31**
- Home Assistant bridge contract: **unchanged / frozen**

## Что вошло в v1.2.142
- поднят UI до `1.2.142`
- `router-agent` **не менялся**, остаётся `0.6.31`
- структура JSON для Home Assistant **не менялась**
- в Home Assistant добавлены helper-сенсоры свежести и stale-индикатор поверх уже существующих timestamp-ов
- обновлён пример dashboard: теперь в HA видно задержку / устаревание snapshot без усиления нагрузки на роутер
- обновлены changelog, release-plan, HA handoff docs, request-ledger и transfer-файлы

## Что вошло в v1.2.141
- поднят UI до `1.2.141`
- `router-agent` **не менялся**, остаётся `0.6.31`
- структура JSON для Home Assistant **не менялась**
- накопленный проектный контекст выгружен в docs: `project-memory`, `request-ledger`, `current-state`
- обновлены changelog, release-plan, HA handoff docs и transfer-файлы

## Next suggested step
- На следующем шаге развивать Host / Traffic diagnostics cards уже поверх стабилизированного HA bridge, не трогая JSON-контракт без отдельного запроса.
