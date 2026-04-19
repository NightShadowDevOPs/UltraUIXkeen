# Current state — UI Mihomo / Ultra

- Date: **2026-04-20**
- UI version: **v1.2.151**
- router-agent version: **0.6.32**
- Repository: `NightShadowDevOPs/UltraUIXkeen`
- Local path: `Y:\Мой диск\Git\UltraUIXkeen`
- Router path: `/opt/UltraUIXkeen`

## What was done in v1.2.151
- left router-agent telemetry/runtime logic untouched so the forwarding path stays conservative and safe
- made secondary Host QoS and Traffic/Users QoS polling viewport-aware: when the card is off-screen, its background refresh loop stays paused
- when the card becomes visible again, a soft refresh is fired so QoS/runtime data is quickly brought up to date
- kept the main traffic live path and the Overview weights chart outside this lazy-visibility logic
- synchronized docs, changelog and chat-transfer bundle for the new release

## Current focus
- reduce remaining UI polling overhead without touching the actual traffic path
- keep Overview traffic weights chart stable under real router load
- continue lightening the Traffic workspace carefully, without breaking QoS, host stats or provider SSL checks

## Next logical step after this release
- observe `v1.2.151` under real router load
- if the runtime is stable, move to safe upstream cherry-picks and maybe one more selective viewport pass for other secondary widgets
