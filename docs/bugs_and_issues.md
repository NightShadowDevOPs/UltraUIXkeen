# Bugs and Issues

- Known reason for this release: zash-agent can occasionally hang/stick.
- Watchdog restarts only agent uhttpd after repeated failed `status`/`ha_snapshot` checks.
- CPU value may still need separate observation if router-agent reports 0.0 constantly.
