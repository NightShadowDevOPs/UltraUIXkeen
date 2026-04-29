# Bugs and issues — v1.2.176

## Fixed

### `ha_snapshot` returned HTTP 502 / CGI timeout

- Status: **fixed**
- Fixed in: **v1.2.174**
- Evidence status: user smoke test returned `HTTP/1.1 200 OK` and JSON with `"ok":true`, `"contract":"zash.ha.snapshot.bundle.v1"`.
- Current release action: documentation cleanup only; do not treat this as an open runtime blocker unless it reproduces again.

### Wrong project path assumption during agent reinstall

- Status: **mitigated in v1.2.175**, hardened in **v1.2.176**
- Problem: commands assumed `/opt/UltraUIXkeen`, while actual project path is `/opt/etc/mihomo` and runtime agent path is `/opt/zash-agent`.
- Current release action: direct apply/check/rollback scripts are shipped under `scripts/` and documented for the real layout.

### No rollback helper in previous apply flow

- Status: **fixed in v1.2.176**
- Action: added `scripts/rollback-zash-agent-v1.2.176.sh`.

## Open

No confirmed open runtime bug is intentionally shipped in `v1.2.176`.

## Watch after deploy

- UI provider list should render after `cmd=mihomo_providers` returns `200`.
- Agent should not show `Агент включён, но недоступен` while `cmd=status` returns `200`.
- `uhttpd` should remain bound to `192.168.0.1:9099`.
