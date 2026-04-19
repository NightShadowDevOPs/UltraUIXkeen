# UltraUIXkeen — Release plan

## Current released package
- **v1.2.142** — HA snapshot freshness and “no data” UX: в Home Assistant добавлены derived helper-сенсоры и карточки свежести; JSON-контракт router-agent / HA не менялся ✅
- **v1.2.141** — project memory export and docs freeze: накопленный проектный контекст выгружен в docs, handoff-файлы обновлены, контракт HA не менялся ✅

## Upcoming sequence
- **v1.2.143** — развить Host / Traffic diagnostics cards, используя уже стабилизированный HA bridge.
- **v1.2.144** — QoS / shaping visibility cleanup и полировка нагрузки на роутер.
- **v1.2.145** — cleanup информационной архитектуры раздела «Трафик» после стабилизации bridge-контуров.

## Package status
- Latest packaged release: **v1.2.142** (`UltraUIXkeen-v1.2.142.zip`)
- Latest chat-transfer pack: **v1.2.142** (`UltraUIXkeen-chat-transfer-v1.2.142.zip`)
- Latest HA handoff pack: **v1.2.142** (`UltraUIXkeen-ha-handoff-v1.2.142.zip`)

## Router-agent status
- Confirmed agent line: **0.6.31**

## What shipped in v1.2.142
- UI raised to **1.2.142**
- Router-agent remained **0.6.31**
- Home Assistant template helpers added for `snapshot`, `traffic`, `users`, `qos` freshness / age
- Example HA dashboard expanded with snapshot freshness and raw timestamp visibility
- HA JSON contract explicitly kept frozen; no router-agent payload shape changes

## What shipped in v1.2.141
- UI raised to **1.2.141**
- Router-agent remained **0.6.31**
- Project memory exported into docs: `docs/project-memory.md`, `docs/request-ledger.md`, `docs/current-state.md`
- Chat transfer / HA handoff / release plan refreshed
- HA JSON contract explicitly frozen for the next step
