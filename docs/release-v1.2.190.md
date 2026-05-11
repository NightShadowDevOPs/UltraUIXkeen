# Release v1.2.190 — Provider panel links UI polish

## Scope

UI-only polish for the provider access links table on the `Tasks / Providers` page.

## What changed

- Provider names are now rendered as compact badges, so short names such as `AdminVPS` are readable instead of being squeezed into plain truncated text.
- Provider access table now uses fixed column sizing via `colgroup` to keep columns aligned across rows.
- The URL input rows are aligned with internal grid columns: label, URL field, open button, delete button.
- Internet panel URL and SSH/local panel URL inputs are shorter and no longer stretch across the whole table.
- `Open` buttons keep a fixed width so rows remain visually stable when one provider has an SSH URL and another one does not.

## Safe boundaries

This release does not change router-agent runtime logic, SSL source selection, Mihomo core, TUN, QoS/routing, provider subscription parsing, users-db limits, `shapers.db`, router reboot flow, Home Assistant, HA DB, native Home Assistant Energy, or SmartLife boiler.

## Expected user-visible result

The providers table should be easier to scan:

- provider name is visible in a badge;
- country selector, active badge and settings badge stay in one aligned provider column;
- panel URL fields are shorter and aligned;
- transition from public panel URL to local SSH panel URL remains manual and non-destructive.

## Checks

- Static file presence: `src/views/TasksPage.vue` updated.
- Version: `package.json` set to `1.2.190`.
- No router-agent install script is required for this release.
