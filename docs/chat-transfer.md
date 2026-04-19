# UltraUIXkeen — current chat transfer note

## Current release
- Текущая версия UI: **v1.2.143**
- Текущая версия `router-agent`: **0.6.31**
- Home Assistant bridge contract: **unchanged / frozen**

## Что вошло в v1.2.143
- поднят UI до `1.2.143`
- `router-agent` **не менялся**, остаётся `0.6.31`
- структура JSON для Home Assistant **не менялась**
- добавлен `docs/model-memory-snapshot.md` со слепком долгоживущего проектного контекста и правил его использования
- добавлен `docs/workflow-rules.md` с рабочим порядком: архивы, commit block, router commands, проверки, обновление docs
- обновлены `release-plan`, `current-state`, `request-ledger`, transfer-файлы

## Что было подтверждено до этого
- метрики с роутера в HA поступают корректно
- helper-сенсоры свежести из `v1.2.142` можно применять без изменения JSON-контракта

## Next suggested step
- Следующим логичным шагом после этого packaging-release сделать `v1.2.144`: развить Host / Traffic diagnostics cards поверх уже стабилизированного HA bridge.
