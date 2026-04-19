# UI Mihomo / Ultra — transfer bundle snapshot

Дата: **2026-04-20**
Версия UI: **v1.2.149**
Версия router-agent: **0.6.32**

## Суть последнего релиза
- router-agent не трогали: backend telemetry cache остался как в `v1.2.148`
- UI получил short-lived dedupe/cache для `traffic_live`, `host_traffic_live`, `lan_hosts`
- живые графики и host telemetry получили fallback на последний стабильный sample
- цель: снизить лишний polling, не задевая реальный трафик на роутере

## Контроль после установки
- Overview weights chart работает
- Traffic live cards не проваливаются в ноль при кратком сбое telemetry
- throughput/latency роутера не хуже прежнего
