30.03.2026 UI Mihomo / Ultra — сообщение для нового чата

Проект: UI Mihomo / Ultra
Репозиторий: NightShadowDevOPs/UltraUIXkeen
Локальная папка проекта: Y:\Мой диск\Git\UltraUIXkeen
Путь на роутере/сервере: /opt/UltraUIXkeen
Стек: Vue 3 + TypeScript + router-agent (shell/cgi на роутере)

Текущие версии:
- UI: v1.2.107
- v1.2.107: UI-фикс для Traffic/QoS и временное отключение редактора конфигурации Mihomo; clarified WAN-only shaping display; Mihomo config editor block disabled to lower router CPU; router-agent не менялся
- router-agent: 0.6.22

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
- Traffic / QoS UI теперь явно разделяет `текущий суммарный трафик` и `лимит uplink/WAN` в WAN-only режиме, чтобы не казалось, будто лимит канала не работает при высоком download/LAN
- в WAN-only режиме интерфейс прямо предупреждает: download/LAN на строке может быть выше лимита, и это само по себе ещё не означает, что uplink shaping не сработал
- блок редактирования `Mihomo → Config` временно выключен из UI, потому что он начал заметно грузить CPU роутера

Что важно не потерять:
- если меняется `router-agent`, нужно синхронизировать версии в `install.sh` и в status API
- в командах для роутера добавлять `clear`
- обновление UI на роутере делается через сам интерфейс UI, а не через `git pull` на роутере
- `config.yaml` editing должен всегда сохранять fallback на эталонный/рабочий конфиг, чтобы при невалидной правке можно было откатиться

Что смотреть дальше:
- отдельно разобраться, почему пользователь видит фактическое насыщение канала при лимите: уже улучшен UI-слой пояснений, но дальше нужен аудит реального поведения shaping на агенте/роутере
- вернуть Mihomo config editing только после облегчения логики/нагрузки, возможно в формате ленивой загрузки или выноса части операций с роутера
