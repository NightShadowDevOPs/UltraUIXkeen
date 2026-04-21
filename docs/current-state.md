# Current state — UI Mihomo / Ultra

- Date: **2026-04-21**
- UI version: **v1.2.167**
- router-agent version: **0.6.32**
- Main focus: safe cleanup глобальной проверки свежести UI-сборки, без роста фоновой нагрузки и без изменения HA export contract

## What was done in v1.2.167
- Глобальная проверка свежести UI-сборки в `sidebar/settings` больше не делает лишний HTML fetch на каждый обычный visible-resume после короткой паузы.
- Автопроверка новой сборки теперь идёт только если ещё не было успешной проверки или online bundle info реально устарел; короткий anti-burst cooldown сохранён.
- Ручная проверка обновления UI, hard refresh, `router-agent`, HA/export shape, SSL-проверки провайдеров и реальный traffic path не менялись.

## Why this matters
- Это тот же безопасный класс работ: не переписывать runtime и не лезть в traffic path, а вычищать лишние wake-up запросы.
- Поскольку composable проверки сборки живёт в глобальном контуре sidebar/settings, лишний fetch HTML бил по самому роутеру почти на ровном месте.
- Теперь UI реже дёргает index/html без пользы, но ручной контроль обновления остаётся полностью рабочим.

## Current safety rules
- do not break automatic SSL-certificate checks for providers
- do not suggest `git pull` as the primary router update path; the built-in UI updater remains the main flow
- every router command block must begin with `clear`
- do not change the router-agent → Home Assistant data structure unless explicitly requested
- if `router-agent` changes later, sync version references in `install.sh`, status API and docs

## Immediate next step
- validate `v1.2.167` on the real router
- confirm that returning to a browser tab no longer causes pointless extra UI-build checks
- confirm that the manual UI update check still works normally
- confirm that Overview traffic weights chart, provider SSL checks and HA/export runtime remain unchanged
- continue upstream review only for low-risk UI-side improvements
