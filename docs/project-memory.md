# Project memory — UI Mihomo / Ultra

## Stable project facts
- Main repository: `NightShadowDevOPs/UltraUIXkeen`
- Local folder: `Y:\Мой диск\Git\UltraUIXkeen`
- Router path: `/opt/UltraUIXkeen`
- UI updates on the router are done through the built-in UI updater, not through `git pull`
- In router command blocks always include `clear`
- If `router-agent` changes, sync the version in `install.sh`, status API and documentation
- Automatic SSL-certificate checks for proxy providers must stay intact

## Current validated baseline
- UI: **v1.2.150**
- router-agent: **0.6.32**

## Latest delivered step
- `v1.2.150` leaves router-agent untouched and calms down secondary Traffic/QoS refresh loops: summary/runtime polling is rarer, repeated status/qos/lan-host reads are short-cached, while the main live traffic contour stays active

## Current development direction
- continue reducing overhead in the Traffic workspace without touching the real packet-forwarding path
- observe what can be borrowed from upstream only when it is cheap operationally and does not add constant polling pressure
- preserve normal work of the Overview traffic weights chart while lightening the UI/runtime contour
- avoid flashy background loading in Host QoS cards when only silent auto-refresh is happening
