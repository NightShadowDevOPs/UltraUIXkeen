# Session Transfer

v1.2.182 adds zash-agent watchdog. Installation is agent-layer only. Runtime verification should run `scripts/check-zash-agent-watchdog-v1.2.182.sh` when source scripts are available on router.

## v1.2.185 — UI Version Bundle Sync Hotfix

- Синхронизация версии UI bundle после v1.2.182: source/package version bumped to `1.2.184`.
- Agent runtime остаётся `0.6.37`; restart/watchdog/maintenance уже установлены отдельно raw-командами.
- Scope: только UI version sync/docs/check scripts, без Mihomo/TUN/QoS/routing/provider SSL.
