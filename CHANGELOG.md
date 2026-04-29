# Changelog

## v1.2.173 — zash-agent startup self-call hotfix
- `router-agent` bumped to `0.6.33`.
- Fixed a startup fragility where `start.sh` called `cmd=rehydrate` through the same local `uhttpd` that was still coming up. Rehydrate now runs directly as a CGI shell command, so UI/API requests do not wait behind that self-call.
- `ssl-refresh.sh` now runs `cmd=ssl_cache_refresh` directly as CGI instead of calling the agent HTTP endpoint from cron.
- `S99zash-agent stop` now cleans stuck `uhttpd` and `api.sh` processes more reliably.
- Installer auto-detects and fills `MIHOMO_CONFIG` for existing `agent.env` when it is missing or points to a non-existing file.
- UI polling, HA/export contract, provider SSL checks as a feature, live traffic path and TUN were intentionally left unchanged.

## v1.2.172 — traffic calmer service and empty states
- `Трафик -> Устройства`: добавлена спокойная service-state сводка над таблицей с количеством показанных строк, индикатором активных фильтров и подсказкой по группировке IP/MAC.
- `Трафик -> Пользователи`: добавлена аналогичная сводка состояния с количеством строк, bucket-count и пояснением по объединению saved labels, browser traffic buckets и live runtime.
- Empty-state в обеих таблицах стал осмысленным: отдельно различаются отсутствие данных и отсутствие совпадений под текущий фильтр/диагностический срез.
- Из empty-state можно сбросить фильтры/фокус/диагностический срез одной кнопкой.
- `router-agent`, HA/export контракт, polling cadence, provider SSL checks, live traffic path и TUN не менялись.


## v1.2.171 — traffic devices compact/advanced split
- `Трафик -> Устройства`: добавлен явный split между `Кратким режимом` и `Расширенным режимом`.
- В кратком режиме экран оставляет основной рабочий контур: поиск, фильтры, таблицу устройств и действия, без развёрнутых служебных блоков поверх списка.
- Диагностические карточки, runtime-summary и служебные подсказки теперь раскрываются отдельной кнопкой `Показать диагностику` / `Скрыть диагностику`.
- Состояние режима сохраняется локально в браузере для текущего оператора.
- Дополнительно зафиксирован отсутствовавший `activeDiagnosticKey`, чтобы скрытие диагностики всегда возвращало нейтральный срез `all`.
- `router-agent`, HA/export контракт, polling cadence, provider SSL checks, live traffic path и TUN не менялись.

## v1.2.170 — traffic users compact/advanced split
- `Трафик -> Пользователи`: добавлен явный split между `Кратким режимом` и `Расширенным режимом`.
- В кратком режиме экран оставляет только рабочие фильтры, фокус по пользователю и основной список, чтобы раздел меньше шумел при обычной работе.
- Диагностика, QoS runtime summary и служебные подсказки теперь раскрываются отдельной кнопкой `Показать диагностику`, без изменения polling, router-agent и HA/export контракта.
- Состояние режима сохраняется локально в браузере для текущего оператора.
