# Current state — UI Mihomo / Ultra

- Date: **2026-04-20**
- UI version: **v1.2.156**
- router-agent version: **0.6.32**
- Main focus: keep reducing router/UI overhead without touching the real traffic forwarding path

## What was done in v1.2.156
- Manual mass latency tests now run with a small concurrency limit instead of blasting all checks at once.
- This makes proxy/group latency checks gentler for the router and the local API when many nodes are tested together.
- Effective test URLs are now resolved more consistently for single and bulk tests when independent latency URLs are enabled.
- `router-agent` stayed at `0.6.32`; this release is UI-side only.

## Current safety rules
- do not break automatic SSL-certificate checks for providers
- do not suggest `git pull` as the primary router update path; the built-in UI updater remains the main flow
- every router command block must begin with `clear`
- if `router-agent` changes later, sync version references in `install.sh`, status API and docs

## Immediate next step
- validate `v1.2.156` on the real router
- confirm that mass latency tests feel normal, but no longer create a sharp burst of parallel checks
- confirm that Overview traffic weights and ordinary traffic runtime still behave normally
- then continue upstream review for one more safe cherry-pick that does not raise background load
