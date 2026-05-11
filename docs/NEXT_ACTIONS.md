# NEXT_ACTIONS — v1.2.187

1. Commit/push release v1.2.187 to GitHub.
2. On router, download and run `router-agent/install-ha-snapshot-cpu-hotfix.sh` via raw GitHub URL.
3. Run compact verification: 5 samples comparing `cmd=status` CPU and `ha_snapshot.status.system.cpu_pct`.
4. Confirm Home Assistant Router Contract CPU updates dynamically.
5. If confirmed, mark v1.2.187 as installed baseline.
## After v1.2.190

- Verify providers table visually after UI update.
- If layout is accepted, consider adding per-provider validation hints for SSH/local panel URL reachability on the PC side.
- Keep SSL checks on subscription URL.

