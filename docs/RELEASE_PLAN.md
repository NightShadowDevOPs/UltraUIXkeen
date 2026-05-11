# RELEASE_PLAN — v1.2.187

1. Подготовить router-agent hotfix для `ha_snapshot.status.system.cpu_pct`.
2. Не менять Home Assistant, HA DB, SmartLife boiler, Mihomo core, TUN, QoS/routing, provider SSL.
3. Добавить raw/manual installer для runtime `/opt/zash-agent/www/cgi-bin/api.sh`.
4. Добавить check/backup/rollback scripts.
5. Собрать обязательные пакеты release/docs/transfer по universal release rules v9.10.2.

Gate markers:

- ARTIFACT_NAMING_STATUS=OK
- DOCS_PACKAGE_STATUS=OK
- TRANSFER_PACKAGE_STATUS=OK
- STATIC_SAFETY_STATUS=OK
- RELEASE_ARTIFACT_STATUS=OK
- BACKUP_SCRIPT_STATUS=OK

## v1.2.190

UI-only provider links layout polish. Provider names are badges, columns are aligned, URL inputs are shorter. Runtime/router-agent logic unchanged.
