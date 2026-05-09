# UI Mihomo Ultra v1.2.180

Router UI and zash-agent maintenance package.

## v1.2.180

Adds a scoped zash-agent watchdog:

- checks `status` and `ha_snapshot`;
- restarts only `/opt/zash-agent` uhttpd when stuck;
- keeps Mihomo core, TUN, QoS, routing and provider SSL checks untouched;
- installs cron line tagged `zash-agent-watchdog`.

Current agent runtime target: `0.6.37`.
