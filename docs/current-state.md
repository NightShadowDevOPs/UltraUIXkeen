# Current state — UI Mihomo / Ultra

- Date: **2026-04-20**
- UI version: **v1.2.150**
- router-agent version: **0.6.32**
- Repository: `NightShadowDevOPs/UltraUIXkeen`
- Local path: `Y:\Мой диск\Git\UltraUIXkeen`
- Router path: `/opt/UltraUIXkeen`

## What was done in v1.2.150
- left router-agent telemetry/runtime logic untouched so the forwarding path stays conservative and safe
- reduced background refresh pressure in secondary Traffic/QoS widgets: Host QoS summary/runtime polls are slower, while live host telemetry remains on its own faster loop only when needed
- added short cache windows for repeated `status`, `qos_status` and `lan_hosts` reads inside QoS widgets, so overlapping refresh cycles do not re-hit the same agent endpoints unnecessarily
- silent auto-refresh no longer flashes unnecessary loading states in Host QoS during normal background updates
- synchronized docs, changelog and chat-transfer bundle for the new release

## Current focus
- reduce remaining UI polling overhead without touching the actual traffic path
- keep Overview traffic weights chart stable under real router load
- continue lightening the Traffic workspace carefully, without breaking QoS, host stats or provider SSL checks

## Next logical step after this release
- observe `v1.2.150` under real router load
- if the runtime is stable, move to safe upstream cherry-picks and another very selective lazy-refresh pass only for truly secondary widgets
