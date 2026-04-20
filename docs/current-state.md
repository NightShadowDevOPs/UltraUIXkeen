# Current state — UI Mihomo / Ultra

- Date: **2026-04-20**
- UI version: **v1.2.161**
- router-agent version: **0.6.32**
- Main focus: continue cutting pointless UI-side background work without touching the real traffic path or the HA export contract

## What was done in v1.2.161
- The hidden-tab pause pattern from `Задачи → Живые логи` was extended to several already viewport-aware operational cards.
- `Router → System`, `Router agent`, `Host QoS` and `Users QoS` no longer keep their background polling alive while the browser tab is hidden.
- As soon as the tab becomes visible again, those cards do a soft refresh and continue normal polling.
- `router-agent` stayed at `0.6.32`; this release is UI-side only and does not touch the HA/export contract.

## What this fixes
- Previously some cards were already off-screen aware but could still continue polling while the browser tab itself was hidden.
- Now another group of operational widgets avoids pointless hidden-tab reads without changing their visible behavior.

## Current safety rules
- do not break automatic SSL-certificate checks for providers
- do not suggest `git pull` as the primary router update path; the built-in UI updater remains the main flow
- every router command block must begin with `clear`
- do not change the router-agent → Home Assistant data structure unless explicitly requested
- if `router-agent` changes later, sync version references in `install.sh`, status API and docs

## Immediate next step
- validate `v1.2.160` and `v1.2.161` together on the real router
- confirm that `Задачи → Живые логи` stops background polling when the block is off-screen
- confirm that `Router → System`, `Router agent`, `Host QoS` and `Users QoS` also stop polling while the browser tab is hidden
- confirm that returning to the tab wakes those widgets up cleanly
- confirm that Overview traffic weights chart and HA/export runtime remain unchanged
