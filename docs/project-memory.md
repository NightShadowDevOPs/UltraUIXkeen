# Project memory — UI Mihomo Ultra

## Current release

- Current release: `v1.2.176`.
- Current packaged agent: `0.6.35`.
- Router: Netcraze, IP `192.168.0.1`.
- Project path: `/opt/etc/mihomo`.
- Runtime agent path: `/opt/zash-agent`.

## Current decision

Deploy `v1.2.176` instead of raw `v1.2.175` because audit required clearer issue ownership and rollback/check tooling.

## Fixed status

`ha_snapshot` 502/CGI timeout is fixed in `v1.2.174` and should not be listed as open unless it reproduces.

## Next operational checks

- `scripts/check-zash-agent-v1.2.176.sh` after upload/deploy.
- UI agent availability.
- Provider list visibility.
- No change in live traffic, TUN, QoS or provider SSL checks.
