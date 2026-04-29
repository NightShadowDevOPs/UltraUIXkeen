# Release plan — UI Mihomo / Ultra

## Current release

- Release: **v1.2.174**
- Agent: **0.6.34**
- Type: hotfix
- Priority: high, because HA export smoke test returns `502 Bad Gateway`.

## Scope

Patch only router-agent HA snapshot behavior:

- make `cmd=ha_snapshot` fast and timeout-safe;
- preserve nested HA contract;
- avoid synchronous heavy rebuild of every component before headers;
- update documentation and transfer notes.

## Out of scope

- no TUN changes;
- no Mihomo core changes;
- no QoS/shaper changes;
- no provider SSL checker redesign;
- no Home Assistant entity/package changes;
- no live traffic path changes.

## Next plan after verification

1. Confirm `ha_snapshot` no longer returns `502`.
2. Check provider list in UI after agent remains stable for several minutes.
3. Check HA/SmartLife consumption of `ha_snapshot`.
4. If needed, tune cache TTLs per block instead of increasing `uhttpd` timeout.
5. Later: continue optimization of traffic pages and router-agent CPU hotspots.
