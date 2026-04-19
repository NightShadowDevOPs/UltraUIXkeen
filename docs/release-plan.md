# UltraUIXkeen — Release plan

## Current released package
- **v1.2.143** — release packaging, transfer kit and workflow snapshot: updated transfer docs, memory snapshot, workflow rules, clean new-chat bootstrap ✅
- **v1.2.142** — HA snapshot freshness and “no data” UX: helper-сенсоры и карточки свежести в HA, JSON-контракт router-agent / HA не менялся ✅
- **v1.2.141** — project memory export and docs freeze: накопленный проектный контекст выгружен в docs, контракт HA не менялся ✅

## Upcoming sequence
- **v1.2.144** — развить Host / Traffic diagnostics cards, используя уже стабилизированный HA bridge.
- **v1.2.145** — QoS / shaping visibility cleanup и полировка нагрузки на роутер.
- **v1.2.146** — cleanup информационной архитектуры раздела «Трафик» после стабилизации bridge-контуров.

## Package status
- Latest packaged release: **v1.2.143** (`UltraUIXkeen-v1.2.143.zip`)
- Latest chat-transfer pack: **v1.2.143** (`UltraUIXkeen-chat-transfer-v1.2.143.zip`)
- Latest HA handoff pack: **v1.2.143** (`UltraUIXkeen-ha-handoff-v1.2.143.zip`)

## Router-agent status
- Confirmed agent line: **0.6.31**

## What shipped in v1.2.143
- UI raised to **1.2.143**
- Router-agent remained **0.6.31**
- added `docs/model-memory-snapshot.md`
- added `docs/workflow-rules.md`
- refreshed transfer docs and release-plan for clean continuation in a new chat
- HA JSON contract explicitly kept frozen; no router-agent payload shape changes
