# UltraUIXkeen — Project memory snapshot

## Stable facts
- Current UI line in this package: **v1.2.143**
- Current router-agent line used with this package: **0.6.31**
- Home Assistant bridge is built around a **single `ha_snapshot` pull** with attribute split inside HA.
- JSON contract for `ha_snapshot` / `ha_status` / `ha_traffic` / `ha_users` / `ha_qos` is intentionally frozen until the user explicitly asks to change it.

## What the user already confirmed
- Роутер и HA уже подтверждали, что данные с роутера поступают.
- Основная жалоба сейчас не «данных нет совсем», а то, что периодически некоторые карточки в HA показывают **«Нет данных»**.
- Пользователь хочет идти дальше в функционал, а не бесконечно бегать по кругу с одними и теми же визуальными хвостами.

## Release memory
- В релизе `v1.2.141` структура payload **не менялась**; это был docs / handoff release.
- В релизе `v1.2.142` структура payload тоже **не меняется**; freshness / stale UX считается только derived-сенсорами внутри HA.
- В релизе `v1.2.143` payload также **не менялся**; это packaging / transfer / workflow release.

## Why this matters
- Любые следующие шаги вокруг HA нужно строить вокруг текущего контракта, а не ломать его.
- Слой удобства и диагностики лучше добавлять на стороне HA-карточек / template helpers, чем раздувать router-agent и нагрузку на роутер.
