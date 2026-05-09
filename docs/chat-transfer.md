# Chat transfer — UI Mihomo Ultra v1.2.176

## Where to continue

Continue from `UltraUIXkeen-v1.2.176.tar.gz`.

## Current focus

`v1.2.176` is a deploy-hardening patch before checking/installing the `v1.2.175` zash-agent line on the router.

## Current router layout

- Project path: `/opt/etc/mihomo`
- Agent runtime: `/opt/zash-agent`
- Router IP: `192.168.0.1`
- Agent endpoint: `http://192.168.0.1:9099/cgi-bin/api.sh`

## What v1.2.176 contains

- `scripts/apply-zash-agent-v1.2.176.sh`
- `scripts/check-zash-agent-v1.2.176.sh`
- `scripts/rollback-zash-agent-v1.2.176.sh`
- `docs/audit-deploy-decision-v1.2.176.md`
- `docs/router-agent-deploy-v1.2.176.md`
- release-docs ZIP with mandatory documentation files.

## Important status

- `ha_snapshot` timeout/502 issue: **fixed in v1.2.174**, confirmed by user smoke test.
- Runtime agent code in this package: **0.6.35**.
- TUN: **do not enable** for this project state.
- Live traffic path: **not changed**.
- Provider SSL checks: **not changed**.
- HA contract: **not changed**.

## Next checks after deploy

1. Run `scripts/check-zash-agent-v1.2.176.sh`.
2. Confirm `STATUS_HTTP=200` and `STATUS_OK=true`.
3. Confirm `HA_SNAPSHOT_HTTP=200` and `HA_SNAPSHOT_OK=true`.
4. Confirm `MIHOMO_PROVIDERS_HTTP=200`.
5. Confirm UI no longer shows agent unavailable.
6. Confirm provider list still renders.

## If deployment fails

Run:

```sh
/opt/bin/sh scripts/rollback-zash-agent-v1.2.176.sh
```


## v1.2.177 — router-agent HA strict JSON hotfix

Закрыт риск невалидных HTTP responses для Home Assistant: строки `shape`, `wireguard-route` и другой stdout от shell helpers больше не могут попасть перед `Content-Type: application/json`. Добавлены безопасная сортировка без `sort -o` и strict wrapper для HA endpoints. Агент: `0.6.36`.
