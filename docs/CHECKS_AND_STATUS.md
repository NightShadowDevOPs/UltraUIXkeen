# CHECKS_AND_STATUS — v1.2.187

## Static checks

- ARTIFACT_NAMING_STATUS=OK
- DOCS_PACKAGE_STATUS=OK
- TRANSFER_PACKAGE_STATUS=OK
- STATIC_SAFETY_STATUS=OK
- RELEASE_ARTIFACT_STATUS=OK
- BACKUP_SCRIPT_STATUS=OK

## Runtime baseline before release

- router-agent endpoint: `http://192.168.0.1:9099/cgi-bin/api.sh`
- `cmd=status`: HTTP 200, JSON OK, live CPU.
- `cmd=ha_status/ha_traffic/ha_users/ha_qos/ha_snapshot`: HTTP 200, JSON OK after v1.2.185/v1.2.186.
- watchdog: `FAIL_COUNT=0`, `LAST_STATUS=OK`.

## Expected post-install check

Run `scripts/check-zash-agent-snapshot-cpu-v1.2.187.sh` or the compact command from release response. Expected output is no more than ~8 lines.
