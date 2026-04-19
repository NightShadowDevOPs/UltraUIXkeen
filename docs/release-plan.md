# UltraUIXkeen — Release plan

## Current released package
- **v1.2.144** — actionable diagnostics cards for Host QoS and Traffic / Users: new clickable diagnostics rows, faster drill-in to problem slices, HA bridge contract left untouched ✅
- **v1.2.143** — release packaging, transfer kit and workflow snapshot: updated transfer docs, memory snapshot, workflow rules, clean new-chat bootstrap ✅
- **v1.2.142** — HA snapshot freshness and “no data” UX: helper-сенсоры и карточки свежести в HA, JSON-контракт router-agent / HA не менялся ✅

## Upcoming sequence
- **v1.2.145** — продолжить operational UX вокруг Host / Traffic diagnostics: ещё понятнее drill-in, сортировки и проблемные состояния без изменения HA bridge contract.
- **v1.2.146** — QoS / shaping visibility cleanup и полировка нагрузки на роутер.
- **v1.2.147** — cleanup информационной архитектуры раздела «Трафик» после стабилизации bridge-контуров.

## Package status
- Latest packaged release: **v1.2.144** (`UltraUIXkeen-v1.2.144.zip`)
- Latest chat-transfer pack: **v1.2.144** (`UltraUIXkeen-chat-transfer-v1.2.144.zip`)
- Latest HA handoff pack: **v1.2.144** (`UltraUIXkeen-ha-handoff-v1.2.144.zip`)

## Router-agent status
- Confirmed agent line: **0.6.31**

## What shipped in v1.2.144
- UI raised to **1.2.144**
- Router-agent remained **0.6.31**
- Host QoS received a new diagnostics row: active traffic, unlabeled hosts, pending drafts, current-slice reset
- Traffic / Users received a new diagnostics row: missing devices, stored-only QoS, near-limit users, active live traffic
- diagnostics cards are clickable and open the relevant slice instead of being passive counters
- HA JSON contract explicitly kept frozen; no router-agent payload shape changes
