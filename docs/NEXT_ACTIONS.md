# Next actions — UI Mihomo Ultra v1.2.179

1. Upload/extract `release-ui-mihomo-ultra-v1.2.179.zip` to the router project path.
2. Run read-only compact check:
   `/opt/bin/sh scripts/check-zash-agent-v1.2.179.sh`
3. If current state is sane, run:
   `/opt/bin/sh scripts/apply-zash-agent-v1.2.179.sh`
4. Verify:
   - `STATUS_VERSION=0.6.37`
   - all HA endpoints return HTTP 200;
   - `ha_snapshot` includes status/traffic/users/qos blocks.
5. If apply fails, use:
   `/opt/bin/sh scripts/rollback-zash-agent-v1.2.179.sh`

Do not change Mihomo/TUN/QoS/routing/provider SSL during this step.
