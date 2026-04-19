# Release plan — UI Mihomo / Ultra

## Recent completed steps
- **v1.2.141** — project memory export and docs freeze: выгружен накопленный проектный контекст в docs, обновлены handoff-файлы, контракт HA не менялся ✅
- **v1.2.140** — router-agent install hotfix: синхронизирован embedded CGI в `install.sh`, чтобы `ha_snapshot` реально доезжал до роутеров ✅
- **v1.2.139** — aggregated HA snapshot: добавлен `ha_snapshot`, пакет HA переведён на single-resource polling ✅
- **v1.2.138** — live verification sync: добит рассинхрон `serverVersion`, обновлены docs по факту live-проверки ✅
- **v1.2.137** — HA export stabilization groundwork ✅
- **v1.2.136** — HA export command set + short cache layer ✅

## Current packaged state
- Latest packaged release: **v1.2.141** (`UltraUIXkeen-v1.2.141.zip`)
- Latest chat-transfer pack: **v1.2.141** (`UltraUIXkeen-chat-transfer-v1.2.141.zip`)
- Latest HA handoff pack: **v1.2.141** (`UltraUIXkeen-ha-handoff-v1.2.141.zip`)
- Current router-agent baseline: **0.6.31**

## What shipped in v1.2.141
- UI raised to **1.2.141**
- `router-agent` intentionally left at **0.6.31**
- HA payload structure intentionally left unchanged
- added: `docs/project-memory.md`
- added: `docs/request-ledger.md`
- added: `docs/current-state.md`
- refreshed changelog, chat-transfer, HA handoff docs, and release materials

## Recommended next releases

### v1.2.142 — traffic page freshness / snapshot age UX
Цель: сделать UI честнее и понятнее без изменения HA-контракта.
- показывать возраст snapshot-данных и время последнего обновления в разделе «Трафик» / операционных карточках
- визуально различать live-refresh и cached snapshot
- не менять JSON-структуру `ha_snapshot`

### v1.2.143 — traffic section cleanup
Цель: довести сам раздел «Трафик».
- нормализовать представление устройств, правил QoS и ограничений
- сократить визуальный шум, убрать дубли и сделать подписи понятнее
- подготовить основу для более чистой операционной сводки по трафику

### v1.2.144 — information architecture pass
Цель: разгрести перегруженные разделы и меню.
- вынести управление конфигом Mihomo из `Settings`
- начать нормальную декомпозицию перегруженных экранов
- сохранить текущие рабочие сценарии без регрессий

### v1.2.145 — provider / host operational block
Цель: продолжить функциональный контур по провайдерам и состоянию узла.
- аккуратнее свести статус хоста, провайдеров, сертификатов и runtime-диагностики
- не ломать существующую проверку SSL-сертификатов провайдеров

## Hard constraints for next steps
- не ломать текущий HA-контракт
- не нагружать роутер тяжёлой аналитикой только ради HA
- при изменениях `router-agent` синхронизировать `install.sh`, `api.sh` и docs
- сохранять полный комплект transfer / handoff документов в каждом релизе
