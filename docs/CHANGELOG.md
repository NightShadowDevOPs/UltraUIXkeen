# Changelog v1.2.184

## v1.2.184

- Bumped UI package version to `1.2.184`.
- Added `scripts/check-ui-version-v1.2.184.sh` for compact router-side version scan.
- Added `scripts/backup-ui-version-state-v1.2.184.sh` for safe frontend directory backup.
- Updated docs/transfer package for UI bundle version sync.
- No agent runtime marker bump: zash-agent remains `0.6.37`.

## v1.2.184
- Fixed zash-agent watchdog false-positive restarts when status and top-level ha_snapshot are OK but nested bundle diagnostics report BUNDLE_OK=false.
