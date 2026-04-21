# Current state — UI Mihomo / Ultra

- Date: **2026-04-21**
- UI version: **v1.2.168**
- router-agent version: **0.6.32**
- Main focus: safe cleanup wake-up refresh for `Router -> System`, without increasing background pressure and without changing the HA export contract

## What was done in v1.2.168
- `Router -> System` now applies a soft anti-burst cooldown before running another wake-up status refresh after quick hide/show or visible-resume cycles.
- Ordinary polling cadence stays intact; this trims duplicate wake-up noise only.
- Manual refresh and details loading remain unchanged.
- `router-agent`, HA/export shape, SSL provider checks and the real traffic path were intentionally left untouched.
- TUN was explicitly reviewed and intentionally left disabled for the current router contour.

## Why this matters
- This keeps the same safe line: fewer pointless wake-up hits against the router, without rewriting runtime logic and without touching live traffic forwarding.
- The `Router -> System` card already has its own activation flow, so repeated visible-resume wake-ups did not need to stack identical refreshes.
- The router should breathe a bit easier, but without any "optimized so hard that the feature vanished" circus.

## Current safety rules
- do not break automatic SSL-certificate checks for providers
- do not suggest `git pull` as the primary router update path; the built-in UI updater remains the main flow
- every router command block must begin with `clear`
- do not change the router-agent → Home Assistant data structure unless explicitly requested
- if `router-agent` changes later, sync version references in `install.sh`, status API and docs
- keep TUN disabled unless a separate real router scenario explicitly requires it

## Immediate next step
- validate `v1.2.168` on the real router
- confirm that fast tab hide/show no longer causes duplicate `Router -> System` wake-up refreshes
- confirm that manual refresh and details loading still behave normally
- confirm that Overview traffic weights, provider SSL checks and HA/export runtime remain unchanged
- continue upstream review only for low-risk UI-side improvements
