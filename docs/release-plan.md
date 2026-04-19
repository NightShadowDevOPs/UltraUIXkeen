# UltraUIXkeen — Release plan

## Current released package
- **v1.2.147** — Router overview traffic jump hotfix: fixed the broken `Открыть` navigation, routed it into the real Traffic workspace, cleaned up Russian QoS wording, HA bridge left untouched ✅
- **v1.2.146** — local severity-first sorting / clearer “why this row is here” hints inside diagnostics slices, still without changing HA bridge contract ✅
- **v1.2.145** — diagnostics drill-in slices and sticky active state: cards now open the full problem subset, active diagnostics stay visible in the toolbar, and Users / Traffic ignores Top N while a diagnostic slice is active ✅
- **v1.2.144** — actionable diagnostics cards for Host QoS and Traffic / Users: new clickable diagnostics rows, faster drill-in to problem slices, HA bridge contract left untouched ✅

## Upcoming sequence
- **v1.2.148** — cleanup информационной архитектуры раздела «Трафик» и более явная видимость QoS/shaping.
- **v1.2.149** — следующий функциональный шаг по traffic UX после стабилизации navigation/QoS контуров.
- **v1.2.150** — дальнейшая полировка operational UX без изменения HA bridge-контракта.

## Package status
- Latest packaged release: **v1.2.147** (`UltraUIXkeen-v1.2.147.zip`)
- Latest chat-transfer pack: **v1.2.147** (`UltraUIXkeen-chat-transfer-v1.2.147.zip`)
- Latest HA handoff pack: **v1.2.147** (`UltraUIXkeen-ha-handoff-v1.2.147.zip`)

## Router-agent status
- Confirmed agent line: **0.6.31**

## What shipped in v1.2.147
- UI raised to **1.2.147**
- Router-agent remained **0.6.31**
- Router overview traffic card now jumps into the actual Traffic route instead of a stale route name string
- The Router overview traffic shortcut now lands in the devices/QoS context
- Key user-facing QoS labels were cleaned up from Host/hosts wording to Russian device-oriented wording
- HA JSON contract explicitly kept frozen; no router-agent payload shape changes
