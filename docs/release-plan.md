# Release plan

- **v1.2.139** — aggregated HA snapshot endpoint + single-resource HA package ✅
- **v1.2.140** — router-agent install hotfix: sync embedded CGI in `install.sh` with `api.sh`, ensure `ha_snapshot` really reaches routers ✅
- **v1.2.141** — first UI consumption of `ha_snapshot` / bundle diagnostics inside the Ultra panel, or explicit cache-age diagnostics if live HA still shows intermittent gaps

## Packaged state

- Latest packaged release: **v1.2.140** (`UltraUIXkeen-v1.2.140.zip`)
- Latest chat-transfer pack: **v1.2.140** (`UltraUIXkeen-chat-transfer-v1.2.140.zip`)
- Latest HA handoff pack: **v1.2.140** (`UltraUIXkeen-ha-handoff-v1.2.140.zip`)

## What shipped in v1.2.140

- UI raised to **1.2.140**
- router-agent raised to **0.6.31**
- fixed drift between `api.sh` and the embedded CGI payload inside `router-agent/install.sh`
- routers updated from raw `install.sh` now really receive the `ha_snapshot` endpoint
- Home Assistant single-resource package remains based on aggregated `ha_snapshot`
