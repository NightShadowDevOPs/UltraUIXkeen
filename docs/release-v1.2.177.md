# Release v1.2.177

Router-agent HA strict JSON hotfix.

## Fixed

- BusyBox `sort -o` stdout leak risk in HA helper TSV paths.
- Strict HA CGI guard for `ha_status`, `ha_traffic`, `ha_users`, `ha_qos`, `ha_snapshot`, `ha_contract_meta`.
- HA invalid header token symptoms from raw `shape` / `wireguard-route` lines before HTTP headers.

## Verification

Run `scripts/apply-zash-agent-v1.2.177.sh`, then `scripts/check-zash-agent-v1.2.177.sh`.

Expected: `STATUS_HTTP=200`, `HA_STATUS_HTTP=200`, `HA_TRAFFIC_HTTP=200`, `HA_USERS_HTTP=200`, `HA_QOS_HTTP=200`, `HA_SNAPSHOT_HTTP=200`.
