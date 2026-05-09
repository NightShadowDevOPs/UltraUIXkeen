# Current state — UI Mihomo / Ultra

- Date: **2026-04-29**
- Release: **v1.2.176**
- Agent runtime/package: **0.6.35**
- Router IP: **192.168.0.1**
- Agent endpoint: `http://192.168.0.1:9099/cgi-bin/api.sh`
- Project path on router: **`/opt/etc/mihomo`**
- Runtime agent path: **`/opt/zash-agent`**

## Confirmed before this release

`v1.2.174` restored `ha_snapshot` and the user confirmed smoke test:

```text
GET /cgi-bin/api.sh?cmd=ha_snapshot
HTTP/1.1 200 OK
{"ok":true,"format_version":1,"contract":"zash.ha.snapshot.bundle.v1",...}
```

`cmd=status` also returned `200 OK` before later reinstall/restart work.

## Why v1.2.176 exists

Strict audit marked the old `ha_snapshot` timeout as a risk because docs still described it like a known problem in places. Runtime was already fixed, but documentation needed explicit open/fixed ownership.

`v1.2.176` therefore:

- keeps agent runtime code at `0.6.35`;
- keeps HA contract unchanged;
- marks `ha_snapshot -> 502/uhttpd timeout` as **fixed in v1.2.174**;
- adds concise deploy checks so the operator can see pass/fail without reading huge JSON;
- adds rollback script for `/opt/zash-agent` backups.

## Current operational layout

The project files on the router are in `/opt/etc/mihomo`. The runtime agent is installed separately in `/opt/zash-agent`.

Do not assume `/opt/UltraUIXkeen` exists on this router.

## Expected verification after deploy

1. `/opt/zash-agent/www/cgi-bin/api.sh` exists and is executable.
2. `/opt/zash-agent/start.sh` exists and is executable.
3. `/opt/etc/init.d/S99zash-agent` exists and is executable.
4. `netstat` shows `192.168.0.1:9099 LISTEN`.
5. `cmd=status` returns `200 OK` and `ok:true`.
6. `cmd=ha_snapshot` returns `200 OK` and `ok:true`.
7. `cmd=mihomo_providers` returns `200 OK`; provider list data is not dumped to logs.
8. UI no longer shows `Агент включён, но недоступен` when endpoint `status` is reachable.

## Do not change in this patch

- Do not enable TUN.
- Do not change Mihomo core configuration.
- Do not change provider SSL checks.
- Do not change QoS/shaper rules.
- Do not change HA entity names or contract fields.


## v1.2.177 — router-agent HA strict JSON hotfix

Закрыт риск невалидных HTTP responses для Home Assistant: строки `shape`, `wireguard-route` и другой stdout от shell helpers больше не могут попасть перед `Content-Type: application/json`. Добавлены безопасная сортировка без `sort -o` и strict wrapper для HA endpoints. Агент: `0.6.36`.
