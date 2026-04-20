# Current state — UI Mihomo / Ultra

- Date: **2026-04-21**
- UI version: **v1.2.163**
- router-agent version: **0.6.32**
- Main focus: continue cutting pointless UI-side background wake-ups without touching the real traffic path or the HA export contract

## What was done in v1.2.163
- This is the next safe patch after `v1.2.162`.
- Additional duplicated wake-up refreshes were removed in operational cards that already had local `watch(...active...)` refresh logic.
- Patched zones:
  - `Router -> System`
  - `Router -> Router agent`
  - `Router -> Host QoS`
  - `Traffic / Users` QoS statistics
- In these places `useSafePolling` no longer auto-fires on `refreshOnEnable` / `refreshOnVisible`, because the component already performs a targeted refresh when the card becomes active again.
- Normal polling cadence, manual refresh behavior and `router-agent -> HA` data shape were left untouched.

## Why this matters
- `v1.2.161` and `v1.2.162` already reduced hidden-tab and Tasks wake-up noise.
- This follow-up removes another class of duplicate refreshes: the component-level watcher and the polling helper were both trying to be helpful at the same time.
- Result: less pointless wake-up chatter to the router, without changing visible runtime semantics.

## Current safety rules
- do not break automatic SSL-certificate checks for providers
- do not suggest `git pull` as the primary router update path; the built-in UI updater remains the main flow
- every router command block must begin with `clear`
- do not change the router-agent → Home Assistant data structure unless explicitly requested
- if `router-agent` changes later, sync version references in `install.sh`, status API and docs

## Immediate next step
- validate `v1.2.163` on the real router
- confirm that quick tab/card resume in Router/System, Router agent, Host QoS and Users QoS no longer produces duplicate wake-up bursts
- confirm that manual refresh/runtime behavior still feels the same
- confirm that Overview traffic weights chart and HA/export runtime remain unchanged
- if stable, continue with one more safe audit of non-traffic operational widgets that still mix visibility watchers with helper-driven polling
