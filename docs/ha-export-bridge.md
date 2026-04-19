# HA export bridge — UI Mihomo / Ultra

Дата: **2026-04-20**
Текущая версия UI: **v1.2.150**
Текущая версия router-agent: **0.6.32**

## Что важно для HA / внешних handoff-пакетов
- В `v1.2.150` router-agent не менялся: HA/export контракт и backend telemetry path оставлены без изменений.
- Изменения релиза находятся в UI-слое: calmer secondary polling в Traffic/QoS виджетах и short cache для повторных status/qos/lan_hosts reads.
- Это релиз про стабилизацию UI-runtime, а не про новый backend API.

## Что проверять после обновления
1. Overview: диаграмма весов трафика обновляется как раньше.
2. Traffic: QoS-виджеты обновляются спокойнее и без лишнего фонового мигания.
3. Router runtime: реальный трафик через роутер не деградирует.

## Следующий мостовой шаг
- если `v1.2.150` стабилен на роутере, можно смотреть следующий безопасный cherry-pick из upstream, но только без увеличения фонового polling и без вмешательства в SSL/provider checks
