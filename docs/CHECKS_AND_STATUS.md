# Checks and status

Project: UI Mihomo Ultra / zash-agent
Release: v1.2.181
Title: Agent Maintenance: backup retention and log rotation

Static/package gates:
- ARTIFACT_NAMING_STATUS=OK
- DOCS_PACKAGE_STATUS=OK
- TRANSFER_PACKAGE_STATUS=OK
- BACKUP_SCRIPT_STATUS=OK
- RELEASE_ARTIFACT_STATUS=OK
- STATIC_SAFETY_STATUS=OK

Runtime gates:
- RUNTIME_SMOKE_STATUS=NOT_RUN_ON_ROUTER_FROM_PACKAGE
- Previous manual router state: watchdog OK, cron every 2 minutes, status endpoint HTTP 200.

Expected after applying maintenance:
- `MAINTENANCE_SCRIPT_EXISTS=yes`
- `MAINTENANCE_CRON_HIT=yes`
- `BACKUPS_COUNT<=7` after next apply run
- `AGENT_LOG_BYTES<=10485760` after rotation policy
