# UI Mihomo Ultra — HA export bridge v1.2.177

HA endpoints router-agent:
- `ha_status`
- `ha_traffic`
- `ha_users`
- `ha_qos`
- `ha_snapshot`

Требование: strict HTTP response — headers + blank line + only JSON body. v1.2.177 добавляет защиту от TSV/stdout leaks (`shape`, `wireguard-route`) до `Content-Type`.

`*_bps` остаются bytes/sec. `qos.qos_enabled` boolean не равен `qos.counts.qos_enabled` counter.
