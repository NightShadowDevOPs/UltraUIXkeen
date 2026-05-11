# TASKS_DONE — v1.2.187

- Зафиксирована причина залипания CPU: stale/fallback значение внутри `ha_snapshot`, а не HA/Lovelace.
- Подготовлен router-agent hotfix для fresh CPU/load overlay в snapshot.
- Добавлены installer/check/backup/rollback scripts.
- Документация и transfer package обновлены под v1.2.187.

## v1.2.189

- Сделан UI для ручного заполнения SSH-адресов панелей провайдеров.
- Сохранение SSH-адресов добавлено в users-db sync.
- Зафиксировано: SSL-проверки остаются по subscription URL, публичные panel URL можно будет закрывать отдельно.

## v1.2.190

UI-only provider links layout polish. Provider names are badges, columns are aligned, URL inputs are shorter. Runtime/router-agent logic unchanged.
