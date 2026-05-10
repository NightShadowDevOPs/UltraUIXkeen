# Changelog v1.2.182

- Changed restart helper to prefer `/opt/etc/init.d/S99zash-agent restart`.
- Added status + ha_snapshot bundle validation after service restart.
- Kept scoped manual fallback if service restart does not restore the API.
- Added release scripts for apply/check/backup/rollback.
- Updated docs and transfer package.
- Minor installer housekeeping: `install-maintenance.sh` now copies itself to `/opt/zash-agent/install-maintenance.sh` when run.
