# UI Mihomo / Ultra — transfer bundle snapshot

Дата: **2026-04-20**
Версия UI: **v1.2.150**
Версия router-agent: **0.6.32**

## Суть последнего релиза
- router-agent не трогали: backend telemetry/API контракт остался как в `v1.2.148`
- в **Host QoS** secondary summary/runtime polling стал реже, live host telemetry оставлена отдельным более быстрым циклом только там, где она реально нужна
- в **Traffic / Users** QoS/runtime background refresh стал спокойнее
- повторные `status`, `qos_status` и `lan_hosts` reads кратко кэшируются внутри UI-потока QoS-виджетов
- основной live path для трафика и обзорная диаграмма весов трафика не переводились в ленивый режим

## Контроль после установки
- Overview weights chart работает и не «засыпает»
- Traffic → Устройства / Пользователи обновляются спокойнее и без лишней фоновой дёрготни
- throughput/latency роутера не хуже прежнего
