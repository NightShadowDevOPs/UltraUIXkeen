# UI Mihomo / Ultra — release plan

## Completed
- **v1.2.137** — HA package bundle + agent version sync ✅
- **v1.2.136** — HA snapshot runtime + short cache ✅

## Current packaged artifacts
- Latest packaged release: **v1.2.137** (`UltraUIXkeen-v1.2.137.zip`)
- Latest chat-transfer pack: **v1.2.137** (`UltraUIXkeen-chat-transfer-v1.2.137.zip`)
- Latest HA handoff pack: **v1.2.137** (`UltraUIXkeen-ha-handoff-v1.2.137.zip`)

## What shipped in v1.2.137
- added a ready Home Assistant bundle in `docs/ha-export/homeassistant/`
- included `configuration-snippet.example.yaml` for `packages: !include_dir_named packages`
- included `smartlife_router_rest.yaml` with ready REST sensors and binary sensors
- included `smartlife_router_templates.yaml` with derived Mbps helpers and friendly summary entities
- included `smartlife_router_dashboard.yaml` as a simple Lovelace dashboard example
- fixed agent status/version sync: after update `serverVersion` should match the installed router-agent version
- refreshed chat-transfer docs, changelog and HA handoff documentation

## Next logical step
- **v1.2.138** — first UI consumption of HA/export payloads or extended router snapshot diagnostics, depending on the test results from the live router
