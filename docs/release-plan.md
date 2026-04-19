# UltraUIXkeen — Release plan

## Current released package
- **v1.2.145** — diagnostics drill-in slices and sticky active state: cards now open the full problem subset, active diagnostics stay visible in the toolbar, and Users / Traffic ignores Top N while a diagnostic slice is active ✅
- **v1.2.144** — actionable diagnostics cards for Host QoS and Traffic / Users: new clickable diagnostics rows, faster drill-in to problem slices, HA bridge contract left untouched ✅
- **v1.2.143** — release packaging, transfer kit and workflow snapshot: updated transfer docs, memory snapshot, workflow rules, clean new-chat bootstrap ✅

## Upcoming sequence
- **v1.2.146** — local severity-first sorting / clearer “why this row is here” hints inside diagnostics slices, still without changing HA bridge contract.
- **v1.2.147** — QoS / shaping visibility cleanup и полировка нагрузки на роутер.
- **v1.2.148** — cleanup информационной архитектуры раздела «Трафик» после стабилизации bridge-контуров.

## Package status
- Latest packaged release: **v1.2.145** (`UltraUIXkeen-v1.2.145.zip`)
- Latest chat-transfer pack: **v1.2.145** (`UltraUIXkeen-chat-transfer-v1.2.145.zip`)
- Latest HA handoff pack: **v1.2.145** (`UltraUIXkeen-ha-handoff-v1.2.145.zip`)

## Router-agent status
- Confirmed agent line: **0.6.31**

## What shipped in v1.2.145
- UI raised to **1.2.145**
- Router-agent remained **0.6.31**
- Host QoS diagnostic cards now open the full corresponding slice instead of focusing only the first row
- Traffic / Users diagnostic cards now open full problem subsets and keep the active diagnostic visible in the toolbar
- while a diagnostic slice is active in Traffic / Users, Top N truncation is bypassed so relevant rows stay visible
- HA JSON contract explicitly kept frozen; no router-agent payload shape changes
