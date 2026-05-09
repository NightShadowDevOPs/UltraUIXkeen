# HA export bridge — v1.2.176

No HA export contract changes in `v1.2.176`.

## Stable contract endpoints

- `cmd=ha_contract_meta`
- `cmd=ha_snapshot`
- `cmd=ha_status`
- `cmd=ha_traffic`
- `cmd=ha_users`
- `cmd=ha_qos`

## Important contract rules

- `ha_snapshot` remains the preferred bundle source for Home Assistant / SmartLife.
- `*_bps` fields mean **bytes/sec**, not bits/sec.
- `counts.qos_enabled` is a counter, not a boolean.
- Consumer should check top-level `ok` and each nested component `status.ok`, `traffic.ok`, `users.ok`, `qos.ok` separately.

## v1.2.176 note

This release only improves deploy/check/rollback documentation and scripts around `zash-agent`. It does not rename HA entities and does not change payload shape.


## v1.2.177 — router-agent HA strict JSON hotfix

Закрыт риск невалидных HTTP responses для Home Assistant: строки `shape`, `wireguard-route` и другой stdout от shell helpers больше не могут попасть перед `Content-Type: application/json`. Добавлены безопасная сортировка без `sort -o` и strict wrapper для HA endpoints. Агент: `0.6.36`.
