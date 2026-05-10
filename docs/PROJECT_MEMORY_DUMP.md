# PROJECT_MEMORY_DUMP — v1.2.187

- v1.2.181 maintenance/log/backup retention installed.
- v1.2.182 restart helper prefers `/opt/etc/init.d/S99zash-agent restart`.
- v1.2.183 UI version sync fixed.
- v1.2.184 watchdog policy fixed false positives; `BUNDLE_OK=false` alone no longer restarts agent if transport is OK.
- v1.2.185 strict endpoint fallback fixed direct HA endpoint JSON.
- v1.2.186 direct HA endpoints became cache-first and fast.
- v1.2.187 prepared to fix stale/fallback `ha_snapshot.status.system.cpu_pct=50` and add load mapping.
