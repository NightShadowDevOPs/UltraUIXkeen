# Checks and status

Gate markers:

- ARTIFACT_NAMING_STATUS=OK
- DOCS_PACKAGE_STATUS=OK
- TRANSFER_PACKAGE_STATUS=OK
- STATIC_SAFETY_STATUS=OK
- BACKUP_SCRIPT_STATUS=OK
- RELEASE_ARTIFACT_STATUS=OK
- RUNTIME_SMOKE_STATUS=NOT_RUN_ON_ROUTER_FROM_PACKAGE

Static checks:

- Shell syntax checked with `bash -n` where compatible.
- Release scripts are executable.
- No known secrets are included.

Runtime status from user before release:

- v1.2.181 maintenance installed: OK.
- Watchdog installed and cron-running: OK.
- Agent status endpoint: HTTP 200 OK.
- zash-agent size after cleanup: 154.7M.
- Init service restart support: confirmed.
