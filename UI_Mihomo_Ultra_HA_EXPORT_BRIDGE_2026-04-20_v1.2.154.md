# HA export bridge — UI Mihomo / Ultra

Дата: **2026-04-20**
Текущая версия UI: **v1.2.154**
Текущая версия router-agent: **0.6.32**

## Что важно для HA / внешних handoff-пакетов
- В `v1.2.154` router-agent не менялся: HA/export контракт и backend telemetry path оставлены без изменений.
- Изменения релиза находятся в UI-слое: во Overview → Traffic вторичный host-side polling теперь останавливается, когда карточка ушла из viewport.
- Основной live traffic contour и обзорная диаграмма весов намеренно не переводились в lazy/off-screen режим.

## Что проверять после обновления
1. Overview: диаграмма весов трафика обновляется как раньше.
2. Traffic: когда карточка трафика вне экрана, secondary host/QoS refresh не долбит background polling.
3. После возврата карточки в viewport host details и QoS-метаданные подтягиваются без ручного обновления.
4. Router runtime: реальный трафик через роутер не деградирует.

## Следующий мостовой шаг
- если `v1.2.154` стабилен на роутере, можно смотреть следующий безопасный cherry-pick из upstream, но только без увеличения фонового polling и без вмешательства в SSL/provider checks
