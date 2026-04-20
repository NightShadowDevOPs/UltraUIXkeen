# Current state — UI Mihomo / Ultra

- Date: **2026-04-20**
- UI version: **v1.2.157**
- router-agent version: **0.6.32**
- Main focus: keep reducing router/UI overhead without touching the real traffic forwarding path

## What was done in v1.2.157
- In **Tasks → Proxy Providers → Panels** stale saved provider records can now be cleaned up directly from the UI.
- Rows that exist only in saved UI settings and are no longer present among active providers are marked with **«сохранён»**.
- Added a bulk action **«Очистить отключённые»** for orphaned provider records.
- Added per-row deletion for saved provider panel settings.
- Deletion clears linked UI state: provider panel URL, per-provider SSL warning threshold, provider icon, and the local panel SSL cache entry.
- `router-agent` stayed at `0.6.32`; this release is UI-side only.

## What this fixes
- Previously disabled providers could remain visible in the Tasks list when their data survived in the saved UI settings.
- Now these entries are removed explicitly from the UI, without touching live provider checks or the traffic path.

## Current safety rules
- do not break automatic SSL-certificate checks for providers
- do not suggest `git pull` as the primary router update path; the built-in UI updater remains the main flow
- every router command block must begin with `clear`
- if `router-agent` changes later, sync version references in `install.sh`, status API and docs

## Immediate next step
- validate `v1.2.157` on the real router
- confirm that disabled/saved-only provider rows are deleted correctly from Tasks
- confirm that active provider panel links and SSL indicators still behave normally
- then continue upstream review for one more safe cherry-pick that does not raise background load
