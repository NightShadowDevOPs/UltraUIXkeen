# Current state after v1.2.187

- UI package version: `1.2.187`.
- zash-agent runtime marker: `0.6.37`.
- Router-agent endpoint: `http://192.168.0.1:9099/cgi-bin/api.sh`.
- Watchdog: installed, policy `transport_ok`, final known status `FAIL_COUNT=0`, `LAST_STATUS=OK`.
- Maintenance: installed, daily cleanup keeps backups/logs under control.
- Restart helper: v1.2.182 service restart path through `/opt/etc/init.d/S99zash-agent restart` with scoped fallback.
- v1.2.185: strict-output fallback fixed direct HA endpoints.
- v1.2.186: direct HA endpoints became cache-first and fast.
- v1.2.187: prepared hotfix for stale/fallback `ha_snapshot.status.system.cpu_pct=50`; snapshot status now overlays live CPU/load.

Safety boundary for v1.2.187: router-agent API only; no Home Assistant, HA DB, native Energy, SmartLife boiler, Mihomo core, TUN, QoS/routing, provider SSL, users-db or shapers.db changes.
