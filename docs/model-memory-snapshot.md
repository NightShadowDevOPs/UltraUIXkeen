# Model memory snapshot — v1.2.176

Continue UI Mihomo Ultra from release `v1.2.176`.

## Current layout

- Router IP: `192.168.0.1`.
- Project path on router: `/opt/etc/mihomo`.
- Runtime agent path: `/opt/zash-agent`.
- Agent endpoint: `http://192.168.0.1:9099/cgi-bin/api.sh`.
- Runtime packaged agent: `0.6.35`.

## Current release purpose

`v1.2.176` is a release-hardening patch after strict audit:

- old `ha_snapshot` timeout/502 is documented as **fixed in v1.2.174**;
- apply/check/rollback scripts are versioned for `v1.2.176`;
- checks are concise and include `status`, `ha_snapshot`, `mihomo_providers`;
- no traffic, Mihomo core, TUN, QoS, provider SSL check or HA contract behavior changed.

## Rules to preserve

- Do not assume `/opt/UltraUIXkeen` exists.
- Do not enable TUN unless explicitly revisited.
- Do not break provider SSL checks.
- Do not mix SmartLife/HA consumer implementation with router-agent contract producer.
- For release archives, keep docs updated and include chat-transfer information.


## v1.2.177 — router-agent HA strict JSON hotfix

Закрыт риск невалидных HTTP responses для Home Assistant: строки `shape`, `wireguard-route` и другой stdout от shell helpers больше не могут попасть перед `Content-Type: application/json`. Добавлены безопасная сортировка без `sort -o` и strict wrapper для HA endpoints. Агент: `0.6.36`.
