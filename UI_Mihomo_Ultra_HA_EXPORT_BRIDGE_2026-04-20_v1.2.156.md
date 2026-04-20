# HA export bridge — UI Mihomo / Ultra

Дата: **2026-04-20**
Текущая версия UI: **v1.2.156**
Текущая версия router-agent: **0.6.32**

## Что важно для HA / внешних handoff-пакетов
- В `v1.2.156` router-agent не менялся: HA/export контракт и backend telemetry path оставлены без изменений.
- Изменения релиза находятся в UI-слое: массовые latency-тесты теперь выполняются мягче и без большого параллельного залпа.
- Логика выбора test URL стала аккуратнее для ручных single/bulk latency checks при включённом independent latency mode.
- Overview traffic contour и связанные HA/export контракты этим релизом не менялись.

## Что проверять после обновления
1. Массовый latency test не создаёт резкого burst-нагрузочного эффекта на роутере.
2. Single/bulk latency test логически используют корректный test URL.
3. Overview: диаграмма весов трафика продолжает работать нормально.
4. Router runtime: реальный трафик через роутер не деградирует.

## Следующий мостовой шаг
- если `v1.2.156` стабилен на роутере, можно продолжать safe cherry-pick review из upstream, но только без роста постоянного polling и без вмешательства в SSL/provider checks
