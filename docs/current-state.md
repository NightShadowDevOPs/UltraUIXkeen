# Current state — UI Mihomo / Ultra

- Date: **2026-04-20**
- UI version: **v1.2.159**
- router-agent version: **0.6.32**
- Main focus: keep reducing router/UI overhead without touching the real traffic forwarding path

## What was done in v1.2.159
- Overview relationship charts now pause their own snapshot polling when the chart widget is outside the viewport or the browser tab is hidden.
- This was applied to **Overview → Traffic Weights by Sources**, **Overview → Traffic Weights by Clients**, and **Overview → Traffic Weights by Rules**.
- As soon as the chart becomes visible again, the UI performs a soft refresh and resumes normal cadence.
- The shared refresh interval setting is still respected; only invisible background churn was cut.
- `router-agent` stayed at `0.6.32`; this release is UI-side only.

## What this fixes
- Previously those Overview charts could keep refreshing their local snapshots even while the user had scrolled past them or switched to another tab.
- Now the charts stay responsive when visible, but stop doing pointless background work when they cannot be seen.

## Current safety rules
- do not break automatic SSL-certificate checks for providers
- do not suggest `git pull` as the primary router update path; the built-in UI updater remains the main flow
- every router command block must begin with `clear`
- if `router-agent` changes later, sync version references in `install.sh`, status API and docs

## Immediate next step
- validate `v1.2.159` on the real router
- confirm that Overview charts by источникам / клиентам / правилам stop background refresh while off-screen
- confirm that they wake up normally after returning into view
- confirm that the Overview traffic weights chart still behaves normally in the visible state
- then continue upstream review for one more safe cherry-pick that does not raise background load
