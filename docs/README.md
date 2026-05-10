# UI Mihomo Ultra v1.2.186 — HA Direct Endpoint Cache-First Hotfix

This release keeps zash-agent runtime marker `0.6.37` and optimizes HA direct endpoints (`ha_status`, `ha_users`, `ha_qos`, `ha_traffic`) by returning stale cache immediately and refreshing stale data in background.

Scope: zash-agent API cache behavior only. No Mihomo core, TUN, QoS/routing, provider SSL, users-db, shapers.db, UI behavior, or router reboot changes.
