# UI Mihomo / Ultra — release plan

## Completed
- **v1.2.139** — aggregated HA snapshot endpoint + single-resource HA package ✅
- **v1.2.138** — ha_status serverVersion sync hotfix ✅
- **v1.2.137** — HA package bundle + agent version sync ✅
- **v1.2.136** — HA snapshot runtime + short cache ✅

## Current packaged artifacts
- Latest packaged release: **v1.2.139** (`UltraUIXkeen-v1.2.139.zip`)
- Latest chat-transfer pack: **v1.2.139** (`UltraUIXkeen-chat-transfer-v1.2.139.zip`)
- Latest HA handoff pack: **v1.2.139** (`UltraUIXkeen-ha-handoff-v1.2.139.zip`)

## What shipped in v1.2.139

- UI raised to **1.2.139**
- router-agent raised to **0.6.30**
- added aggregated `ha_snapshot` endpoint with one JSON bundle for `status` / `traffic` / `users` / `qos`
- switched the default Home Assistant REST package to the single `ha_snapshot` resource to reduce parallel polling and help stabilize router metrics
- refreshed HA handoff docs, sample payloads and chat-transfer notes

## What shipped in v1.2.138

- router-agent raised to **0.6.29**
- fixed the remaining `ha_status.agent.serverVersion` mismatch; the HA snapshot now reports the installed runtime version directly
- release/docs refreshed after live router verification

## Next logical step
- **v1.2.140** — first UI consumption of `ha_snapshot` / bundle diagnostics inside the Ultra panel, or explicit cache-age diagnostics if live HA still shows intermittent gaps
