# Changelog

## v1.2.165 — safe upstream UI hardening
- после safe upstream review взяты только два низкорисковых UI-хвоста, без новых poller-циклов и без изменений `router-agent`
- `Прокси`: добавлена защита для `proxiesRef`, чтобы ранний lifecycle / пустой ref не ломал scroll restore и scroll handler
- `Соединения`: добавлен явный empty-state, когда строк нет, чтобы экран не выглядел зависшим или сломанным
- `router-agent`, HA/export contract, SSL-проверки провайдеров, Overview traffic contour и реальный traffic path не менялись

## v1.2.164 — overview router-health wake-up dedupe
- убран ещё один дублирующийся wake-up refresh в `Обзор -> Router Health`
- карточка уже делала собственный refresh при повторном входе в viewport, поэтому у `useSafePolling` отключён дополнительный авто-wake-up по `refreshOnEnable` / `refreshOnVisible`
- обычный polling cadence, ручное обновление, `router-agent`, HA/export shape, SSL-проверки и traffic/runtime path не менялись

## v1.2.163 — wake-up dedupe follow-up for operational cards
- убраны дополнительные дублирующиеся wake-up refresh после hidden-tab / visible-resume для `Router -> System`, `Router -> Router agent`, `Router -> Host QoS` и QoS-статистики в `Трафик / Пользователи`
- там, где уже были локальные `watch(...active...)` с ручным refresh, у `useSafePolling` отключён автозапуск по `refreshOnEnable` / `refreshOnVisible`, чтобы не было двойных однотипных запросов
- обычный polling cadence, ручные действия, `router-agent`, HA/export shape и traffic/runtime path не менялись

## v1.2.162 — Tasks visible-resume anti-burst restore
- восстановлен пропущенный safe-патч поверх `v1.2.161`, который не дошёл отдельным архивом
- страница `Задачи`: возврат на видимую вкладку теперь не должен подряд дёргать одинаковые refresh-запросы для `router-agent status`, `Живые логи` и upstream-проверки
- visible-resume обновления для этих трёх контуров теперь идут через мягкую очередь с коротким stagger и cooldown
- обычный polling, ручное обновление и структура данных `router-agent -> HA` не менялись
- `router-agent` оставлен на `0.6.32`

## v1.2.157 — cleanup for disabled proxy-provider panel entries
- Добавлена явная очистка сохранённых записей в блоке **Задачи → Прокси-провайдеры → панели управления**.
- Строки, которые остались только в локально сохранённых настройках и уже отсутствуют среди активных провайдеров, теперь помечаются бейджем **«сохранён»**.
- Появилась массовая кнопка **«Очистить отключённые»** и удаление конкретной строки прямо из таблицы.
- При удалении чистятся связанные UI-настройки: URL панели, индивидуальный SSL-порог и иконка провайдера.
- Это исправляет хвост, из-за которого отключённые SSL-провайдеры оставались висеть в списке задач даже после исчезновения из активного контура.

## v1.2.156 - safer mass latency tests with lighter router pressure
- raised UI package version to `1.2.156`
- kept `router-agent` unchanged at `0.6.32`; no backend telemetry/API contract changes in this release
- mass latency tests no longer fire all proxy checks in one uncontrolled burst: UI now runs them with a small concurrency limit so router/API pressure stays more even
- single-proxy and bulk/manual latency tests now resolve the effective test URL more consistently when independent latency URLs are enabled
- this release is deliberately UI-only and does not touch provider SSL checks, traffic forwarding or the main Overview traffic-weights contour
- documentation, transfer files and memory snapshot docs refreshed for `v1.2.156`

## v1.2.155 - slower off-screen overview traffic live polling
- raised UI package version to `1.2.155`
- kept `router-agent` unchanged at `0.6.32`; no backend telemetry/API contract changes in this release
- kept the Overview traffic live contour active, but when the traffic card is outside the viewport its main live polling now slows down from 4s to 8s instead of running at full cadence
- when the traffic card comes back into view, UI performs an immediate live refresh and returns to the normal 4s cadence so the Overview traffic-weights diagram feels normal while visible
- secondary host-detail polling remains viewport-aware as delivered in `v1.2.154`
- documentation, transfer files and memory snapshot docs refreshed for `v1.2.155`

## v1.2.154 - lighter host-side background refresh in overview traffic card
- raised UI package version to `1.2.154`
- kept `router-agent` unchanged at `0.6.32`; no backend telemetry/API contract changes in this release
- added viewport-aware pause for secondary host-detail polling inside Overview → Traffic: off-screen host metadata refresh no longer keeps spinning when the traffic card is outside the viewport
- kept the main live traffic contour untouched so the Overview traffic weights chart continues to update normally
- slightly slowed secondary expanded-host remote-target refresh and Host QoS metadata refresh to reduce background pressure without affecting packet forwarding
- documentation, transfer files and memory snapshot docs refreshed for `v1.2.154`

## v1.2.153 - viewport-aware lazy polling for overview router health
- raised UI package version to `1.2.153`
- kept `router-agent` unchanged at `0.6.32`; no backend telemetry/API contract changes in this release
- added viewport-aware lazy polling to `RouterHealth`: when the Overview router health card is outside the viewport, its periodic `/version` probe pauses instead of continuing to spin in the background
- when the card becomes visible again, UI triggers a soft refresh so API badge / latency state returns quickly without a manual reload
- kept the main traffic live contour untouched so the Overview traffic weights chart keeps behaving normally
- documentation, transfer files and memory snapshot docs refreshed for `v1.2.153`

## v1.2.152 - viewport-aware lazy polling for router resources and router agent cards
- raised UI package version to `1.2.152`
- kept `router-agent` unchanged at `0.6.32`; no backend telemetry/API contract changes in this release
- extended viewport-aware lazy polling to Router → Resources and router-agent cards so off-screen host-status widgets stop background refresh until they are actually visible
- when those cards return into view, UI now performs a soft runtime refresh without disturbing the main traffic live contour
- documentation, transfer files and memory snapshot docs refreshed for `v1.2.152`
