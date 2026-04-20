# Current state — UI Mihomo / Ultra

- Date: **2026-04-20**
- UI version: **v1.2.158**
- router-agent version: **0.6.32**
- Main focus: keep reducing router/UI overhead without touching the real traffic forwarding path

## What was done in v1.2.158
- In **Tasks → Proxy Providers → Panels** provider rows now expose their source more clearly: active runtime vs saved-only UI state.
- Active rows are marked explicitly, and rows with persisted UI settings show a separate saved-state badge.
- Deleting an active row now removes only the saved UI settings and keeps the live runtime row visible.
- Deleting a saved-only row removes it fully from the table, so no ghost tail remains.
- Added a small state summary above the table for active vs saved-only counts.
- `router-agent` stayed at `0.6.32`; this release is UI-side only.

## What this fixes
- Previously the delete action could look ambiguous: a provider might stay visible after deletion simply because it was still active at runtime.
- Now the UI explicitly explains that difference, and the visual state after deletion is much easier to read.

## Current safety rules
- do not break automatic SSL-certificate checks for providers
- do not suggest `git pull` as the primary router update path; the built-in UI updater remains the main flow
- every router command block must begin with `clear`
- if `router-agent` changes later, sync version references in `install.sh`, status API and docs

## Immediate next step
- validate `v1.2.158` on the real router
- confirm that active/saved-only provider states are visually clear in Tasks
- confirm that active provider panel links and SSL indicators still behave normally
- then continue upstream review for one more safe cherry-pick that does not raise background load
