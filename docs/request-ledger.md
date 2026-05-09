# Request ledger — v1.2.176

## Completed in this release

- Continued project from the unavailable prior release line.
- Took strict audit result as deploy gate input.
- Created v1.2.176 patch before deploy.
- Added concise status/HA/provider smoke checks.
- Added rollback helper.
- Updated documentation and release-docs package.

## Still to verify later on router

- UI shows agent as available.
- Provider list is visible.
- `ha_snapshot` remains `200 OK`.
- No provider SSL check regression.
- No live traffic impact.


## v1.2.177 — router-agent HA strict JSON hotfix

Закрыт риск невалидных HTTP responses для Home Assistant: строки `shape`, `wireguard-route` и другой stdout от shell helpers больше не могут попасть перед `Content-Type: application/json`. Добавлены безопасная сортировка без `sort -o` и strict wrapper для HA endpoints. Агент: `0.6.36`.
