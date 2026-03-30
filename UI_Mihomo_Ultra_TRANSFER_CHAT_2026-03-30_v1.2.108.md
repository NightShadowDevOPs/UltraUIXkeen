30.03.2026 UI Mihomo / Ultra — сообщение для нового чата

Проект: UI Mihomo / Ultra
Репозиторий: NightShadowDevOPs/UltraUIXkeen
Локальная папка проекта: Y:\Мой диск\Git\UltraUIXkeen
Путь на роутере/сервере: /opt/UltraUIXkeen
Стек: Vue 3 + TypeScript + router-agent (shell/cgi на роутере)

Текущие версии:
- UI: v1.2.108
- v1.2.108: router-agent 0.6.23 перевёл hard bandwidth shaping на IFB ingress downlink path с fallback на legacy LAN egress; Mihomo config editor по-прежнему временно отключён в UI ради снижения CPU нагрузки
- router-agent: 0.6.23

Что уже сделано по Mihomo/UI:
- страница `Mihomo` выделена в отдельный рабочий раздел
- внутри Mihomo страница разбита на вкладки/подразделы, чтобы экран не был бесконечной простынёй
- внутри `Mihomo → Конфигурация` сделаны внутренние вкладки (`Editor / Overview / Structured editors / Diagnostics / Compare / History`), но сам тяжёлый блок редактирования сейчас временно отключён из-за нагрузки на CPU роутера
- `Router` разбит на разделы `Обзор / Трафик / Сеть`
- есть safe managed-config flow: `draft / validate / apply / rollback / baseline / history`
- YAML-редактор оставлен как fallback в кодовой базе, но сейчас не монтируется в UI

Что уже переведено в формы:
- `dns`: nameserver, fallback, fake-ip-filter, dns-hijack, nameserver-policy, fallback-filter и связанные поля
- `rules`: фильтр, шаблоны типовых правил, form-поля для `type / payload / target / params`, quick-chips
- `tun / profile / sniffer`: базовые structured-формы
- `proxies`: большой form-driven редактор по полям, type-aware поведение и сценарный мастер создания
- `proxy-groups`: form-driven редактор состава группы, type-aware профиль, chips для `proxies / use / providers`
- `proxy-providers` и `rule-providers`: более понятные карточки с поиском, profile/presets и разбиением по смысловым блокам

Что важно по текущему состоянию:
- Mihomo config editor временно выключен из UI, потому что начал заметно грузить CPU роутера
- hard bandwidth shaping больше не должен опираться только на legacy LAN egress path: router-agent 0.6.23 пытается поднять IFB ingress redirect и шейпить download через IFB
- если IFB на конкретной прошивке/ядре недоступен, агент автоматически откатывается на старый режим LAN egress, а в `status` / `qos_status` теперь видно configured/effective mode и готовность IFB
- UI-объяснение WAN-only для QoS уже добавлено, но следующий акцент теперь именно на реальном ограничении канала, а не на косметике

Что важно не потерять:
- если меняется `router-agent`, нужно синхронизировать версии в `install.sh` и в status API
- в командах для роутера добавлять `clear`
- обновление UI на роутере делается через сам интерфейс UI, а не через `git pull` на роутере
- `config.yaml` editing должен всегда сохранять fallback на эталонный/рабочий конфиг, чтобы при невалидной правке можно было откатиться

Что смотреть дальше:
- проверить на живом роутере, что `status`/`qos_status` показывают `shaperDownlinkMode=ifb` и `shaperIfbReady=true`
- если клиент всё ещё высаживает канал даже в IFB режиме, дальше разбирать уже конкретный tc/iptables/offload path на прошивке, а не UI
- вернуть Mihomo config editing только после облегчения логики/нагрузки, возможно в формате ленивой загрузки или выноса части операций с роутера
