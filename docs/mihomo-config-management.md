# Mihomo config management (safe foundation)

В релизе v1.2.75 добавлен первый безопасный этап управления `config.yaml` через `router-agent`.

## Что есть

- **active** — текущий рабочий `config.yaml`
- **draft** — отдельный черновик на роутере
- **baseline** — эталонный конфиг для аварийного восстановления
- **history** — ревизии предыдущих активных конфигов

## Pipeline применения

1. Пользователь редактирует draft в UI
2. Draft сохраняется на роутер
3. Agent валидирует candidate локально через бинарник Mihomo / clash-meta
4. Agent делает snapshot текущего active
5. Candidate записывается в `config.yaml`
6. Mihomo перезапускается
7. Если запуск неудачен — идёт rollback на предыдущий active
8. Если rollback не помог — идёт fallback на baseline

## Что нельзя делать обычным Save

Обычное сохранение меняет только **draft**.

**Baseline не должен перезаписываться** обычным редактированием.
Для baseline есть отдельное действие: **Make active baseline**.

## Команды router-agent

- `mihomo_cfg_state`
- `mihomo_cfg_get&kind=active|draft|baseline`
- `mihomo_cfg_put&kind=draft`
- `mihomo_cfg_copy&from=active|baseline&to=draft`
- `mihomo_cfg_validate&kind=draft|active|baseline`
- `mihomo_cfg_apply`
- `mihomo_cfg_set_baseline_from_active`
- `mihomo_cfg_restore_baseline`
- `mihomo_cfg_history`
- `mihomo_cfg_get_rev&rev=N`
- `mihomo_cfg_restore_rev&rev=N`

## Что логично делать дальше

- diff между active / draft / baseline
- более подробный UI для причин validate/apply/rollback
- отдельный просмотр last error / last apply result
- потом — частично-структурированный редактор популярных секций YAML
