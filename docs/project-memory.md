# UltraUIXkeen — Project memory snapshot

## Stable facts
- Current UI line in this package: **v1.2.147**
- Current router-agent line used with this package: **0.6.31**
- Home Assistant bridge is built around a **single `ha_snapshot` pull** with attribute split inside HA.
- JSON contract for `ha_snapshot` / `ha_status` / `ha_traffic` / `ha_users` / `ha_qos` is intentionally frozen until the user explicitly asks to change it.

## What the user already confirmed
- Роутер и HA уже подтверждали, что данные с роутера поступают.
- Основная жалоба сейчас не «данных нет совсем», а то, что навигация и отдельные UI-хвосты местами сбивают и мешают быстро попасть в нужный контур.
- Пользователь хочет идти дальше в функционал, а не бесконечно спорить с кривыми кнопками и хвостами терминологии.

## Release memory
- В релизе `v1.2.144` payload также **не менялся**; это UI/diagnostics release поверх уже стабилизированного bridge-контракта.
- В релизе `v1.2.145` payload по-прежнему **не меняется**; доработан именно operator UX вокруг diagnostics slices.
- В релизе `v1.2.146` payload по-прежнему **не меняется**; добавлены severity-first сортировка и поясняющие причины внутри diagnostic slices.
- В релизе `v1.2.147` payload по-прежнему **не меняется**; исправлен переход из карточки роутера в раздел трафика и упрощены пользовательские QoS-подписи.

## Why this matters
- Любые следующие шаги вокруг HA нужно строить вокруг текущего контракта, а не ломать его.
- Слой удобства и диагностики лучше добавлять на стороне UI/HA-карточек, чем раздувать router-agent и нагрузку на роутер.
