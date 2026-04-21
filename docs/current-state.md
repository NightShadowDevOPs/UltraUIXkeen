# Current state — UI Mihomo / Ultra

- Date: **2026-04-21**
- UI version: **v1.2.165**
- router-agent version: **0.6.32**
- Main focus: safe upstream cherry-pick only where it hardens UI behavior without increasing router load or touching the HA export contract

## What was done in v1.2.165
- После safe upstream review взяты только два низкорисковых UI-хвоста.
- `Прокси`: добавлена защита для `proxiesRef`, чтобы ранний lifecycle / пустой ref не ломал scroll restore и обработчик scroll.
- `Соединения`: добавлен явный empty-state, когда в таблице нет строк.
- `router-agent`, polling cadence, manual refresh, HA/export shape, SSL-проверки провайдеров и реальный traffic path не менялись.

## Why this matters
- Это не ещё один “хитрый оптимизатор”, который может случайно расковырять runtime.
- Патч закрывает два UI-хвоста, которые полезны пользователю и почти не несут риска роутеру.
- После серии wake-up dedupe это нормальный следующий шаг: брать только безопасные куски из upstream, а не тащить всё подряд.

## Current safety rules
- do not break automatic SSL-certificate checks for providers
- do not suggest `git pull` as the primary router update path; the built-in UI updater remains the main flow
- every router command block must begin with `clear`
- do not change the router-agent → Home Assistant data structure unless explicitly requested
- if `router-agent` changes later, sync version references in `install.sh`, status API and docs

## Immediate next step
- validate `v1.2.165` on the real router
- confirm that `Прокси` no longer has fragile behavior around empty / not-yet-mounted `proxiesRef`
- confirm that `Соединения` shows a normal empty-state instead of a visually broken blank table
- confirm that Overview traffic weights chart, provider SSL checks and HA/export runtime remain unchanged
- continue upstream review only for low-risk UI-side improvements
