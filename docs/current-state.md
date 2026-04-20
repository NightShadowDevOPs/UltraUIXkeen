# Current state — UI Mihomo / Ultra

- Date: **2026-04-20**
- UI version: **v1.2.155**
- router-agent version: **0.6.32**
- Main focus: keep reducing router/UI overhead in traffic-related telemetry contours without touching the real traffic forwarding path

## What was done in v1.2.155
- Overview → Traffic main live polling now keeps the normal 4s cadence only while the traffic card is visible.
- When the card is off-screen, the same live polling slows down to 8s instead of hammering at the full cadence.
- When the card becomes visible again, UI performs an immediate live refresh and returns to the normal cadence.
- Secondary host-detail polling from `v1.2.154` remains viewport-aware and paused off-screen.
- router-agent stayed at `0.6.32`; this release is UI-side only.

## Current safety rules
- do not break automatic SSL-certificate checks for providers
- do not suggest `git pull` as the primary router update path; the built-in UI updater remains the main flow
- every router command block must begin with `clear`
- if router-agent changes later, sync version references in `install.sh`, status API and docs

## Immediate next step
- observe `v1.2.155` under real router load
- confirm that the Overview traffic weights chart still feels normal while visible
- confirm that off-screen Overview → Traffic polling is quieter than before
- then review one more cheap secondary contour or a safe upstream cherry-pick that does not raise background load
