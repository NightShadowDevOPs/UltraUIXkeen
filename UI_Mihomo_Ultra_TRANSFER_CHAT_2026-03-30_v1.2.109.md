30.03.2026 UI Mihomo / Ultra — сообщение для нового чата

Проект: UI Mihomo / Ultra
Репозиторий: NightShadowDevOPs/UltraUIXkeen
Локальная папка проекта: Y:\Мой диск\Git\UltraUIXkeen
Путь на роутере/сервере: /opt/UltraUIXkeen
Стек: Vue 3 + TypeScript + router-agent (shell/cgi на роутере)

Текущие версии:
- UI: v1.2.109
- router-agent: 0.6.24

Что важно по текущему состоянию:
- Mihomo config editor временно отключён в UI, чтобы не грузить CPU роутера
- на живом роутере с XKeen 1.1.3.9 / kernel 4.9-ndm-5 подтверждено, что IFB не поднимается (`ifb4wan not present`)
- из-за этого router-agent 0.6.24 делает следующий порядок downlink shaping: `ifb` -> `wan-police` (drop-based hashlimit на forwarded WAN→LAN трафике) -> `lan-egress`
- в `status` / `qos_status` теперь есть `shaperDownlinkMode`, `shaperConfiguredMode`, `shaperIfbReady`, `shaperPoliceReady`, `shaperPoliceBackend`

Что проверить после установки:
- выполнить `cmd=shape` для живого клиента с лимитом
- проверить, что `status` / `qos_status` показывают `shaperDownlinkMode=wan-police` и `shaperPoliceReady=true`, если IFB по-прежнему отсутствует
- если канал всё равно высаживается, дальше копать offload / fastpath / bridge-forwarding path на прошивке

Что не потерять:
- если меняется router-agent, нужно синхронизировать версии в `install.sh` и status API
- в командах для роутера добавлять `clear`
- обновление UI на роутере делается через сам интерфейс UI, а не через `git pull` на роутере
