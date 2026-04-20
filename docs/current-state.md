# Current state — UI Mihomo / Ultra

- Date: **2026-04-21**
- UI version: **v1.2.164**
- router-agent version: **0.6.32**
- Main focus: finish the remaining safe wake-up dedupe tail without touching the real traffic path or the HA export contract

## What was done in v1.2.164
- This is the next safe patch after `v1.2.163`.
- The remaining wake-up duplicate in `Overview -> Router Health` was removed.
- The card already performs its own refresh when it re-enters the viewport, so `useSafePolling` no longer auto-fires an extra wake-up refresh through `refreshOnEnable` / `refreshOnVisible`.
- Normal polling cadence, manual refresh behavior and `router-agent -> HA` data shape were left untouched.

## Why this matters
- `v1.2.162` reduced Tasks visible-resume bursts.
- `v1.2.163` removed similar overlaps in System / Router agent / Host QoS / Users QoS.
- `v1.2.164` closes the same pattern in Overview router health, so one more invisible “double helpfulness” path is gone.

## Current safety rules
- do not break automatic SSL-certificate checks for providers
- do not suggest `git pull` as the primary router update path; the built-in UI updater remains the main flow
- every router command block must begin with `clear`
- do not change the router-agent → Home Assistant data structure unless explicitly requested
- if `router-agent` changes later, sync version references in `install.sh`, status API and docs

## Immediate next step
- validate `v1.2.164` on the real router
- confirm that `Overview -> Router Health` no longer performs duplicate wake-up refreshes after returning into view
- confirm that manual refresh/runtime behavior still feels the same
- confirm that Overview traffic weights chart and HA/export runtime remain unchanged
- if stable, continue upstream review only for safe, low-risk load reductions
