# Release plan v1.2.182

1. Update `router-agent/restart-agent.sh`.
2. Add install/check/backup/rollback scripts for restart helper hotfix.
3. Keep runtime scope narrow: zash-agent restart only.
4. Preserve Mihomo core, TUN, QoS/routing, provider SSL, users-db and shapers.
5. Deliver router-agent runtime changes through raw/manual commands because UI updater does not deploy agent scripts.
