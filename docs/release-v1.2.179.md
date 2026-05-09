# Release v1.2.180

## Scope

Normalized release package after the `v1.2.178` zash-agent hotfix.

## Included changes

- Main source version bumped to `1.2.180`.
- `router-agent/install.sh` from `v1.2.178` is included with agent marker `0.6.37`.
- Current apply/check/rollback/backup scripts use `v1.2.180` naming.
- Lightweight backup is used instead of full `/opt/zash-agent` tar backup.
- Documentation and transfer files are normalized to universal release rules `v9.10.2`.

## Not changed

- Mihomo core.
- TUN.
- QoS/shaper semantics.
- Routing rules.
- Provider SSL checks.
