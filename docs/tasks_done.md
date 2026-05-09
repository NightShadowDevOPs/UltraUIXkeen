# Tasks done — v1.2.176

- Reviewed strict audit output for deploy decision.
- Converted the `ha_snapshot` timeout note from ambiguous known issue to explicit **fixed in v1.2.174** status.
- Added concise smoke checker for status, HA snapshot and Mihomo providers.
- Added scoped apply script for `/opt/zash-agent`.
- Added rollback helper for `/opt/zash-agent` backups.
- Updated project documentation and generated release-docs package.


## v1.2.177 — router-agent HA strict JSON hotfix

Закрыт риск невалидных HTTP responses для Home Assistant: строки `shape`, `wireguard-route` и другой stdout от shell helpers больше не могут попасть перед `Content-Type: application/json`. Добавлены безопасная сортировка без `sort -o` и strict wrapper для HA endpoints. Агент: `0.6.36`.
