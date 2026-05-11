# SESSION_TRANSFER — v1.2.187

## Summary

Prepared router-agent-only release v1.2.187 to fix stale CPU in HA snapshot bundle.

## Facts

- `cmd=status` CPU is live.
- `cmd=ha_snapshot` CPU could stay at `50`.
- HA uses `sensor.smartlife_router_cpu` from `ha_snapshot.status.system.cpu_pct`.
- v1.2.187 overlays snapshot status CPU/load with fresh status/cache/proc data.

## Files

- `router-agent/install-ha-snapshot-cpu-hotfix.sh`
- `router-agent/install.sh`
- `scripts/check-zash-agent-snapshot-cpu-v1.2.187.sh`
- `scripts/apply-zash-agent-snapshot-cpu-v1.2.187.sh`
- `scripts/backup-zash-agent-snapshot-cpu-v1.2.187.sh`
- `scripts/rollback-zash-agent-snapshot-cpu-v1.2.187.sh`
## v1.2.190 session note

Provider access links table was polished: names are badges, columns are aligned, URL fields are shorter. This is UI-only and does not change router-agent provider/SSL mechanics.

