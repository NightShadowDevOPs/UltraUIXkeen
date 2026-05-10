# UI Mihomo Ultra v1.2.182

Router UI and zash-agent maintenance package.

## v1.2.182

Adds a scoped zash-agent watchdog:

- checks `status` and `ha_snapshot`;
- restarts only `/opt/zash-agent` uhttpd when stuck;
- keeps Mihomo core, TUN, QoS, routing and provider SSL checks untouched;
- installs cron line tagged `zash-agent-watchdog`.

Current agent runtime target: `0.6.37`.

## v1.2.185 — UI Version Bundle Sync Hotfix

- Синхронизация версии UI bundle после v1.2.182: source/package version bumped to `1.2.184`.
- Agent runtime остаётся `0.6.37`; restart/watchdog/maintenance уже установлены отдельно raw-командами.
- Scope: только UI version sync/docs/check scripts, без Mihomo/TUN/QoS/routing/provider SSL.
