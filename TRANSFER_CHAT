UI Mihomo / Ultra — transfer update v1.2.48

What changed in this rebuild:
- added UI cache validation in Settings: current loaded bundle vs bundle currently served by the router HTML
- added hard refresh for UI cache: unregister service workers + clear CacheStorage before forced reload
- added frontend build stamp visibility in Settings and made the sidebar footer version line brighter for quicker post-update verification
- router-agent code not changed in this release

Current versions:
- UI: v1.2.48
- router-agent: 0.6.12

13.03.2026 UI Mihomo / Ultra — сообщение для нового чата (вставь целиком)

Проект: UI Mihomo / Ultra
Новый основной репозиторий: https://github.com/NightShadowDevOPs/UltraUIXkeen
Локальная папка проекта: Y:\Мой диск\Git\UltraUIXkeen
Путь на роутере/сервере: /opt/UltraUIXkeen
Стек: Vue 3 + TypeScript + router-agent (shell/cgi на роутере)

Текущие версии:
- UI: v1.2.48
- router-agent: 0.6.12

Правила по проекту:
- всегда давать архив релиза, commit message и отдельный блок команд для роутера
- пользователь пушит через GitHub Desktop
- обновление на роутере идёт через UI, а не через git pull
- если меняется router-agent, синхронизировать версию в install.sh и status API
- в каждом релизе обновлять docs/chat-transfer.md и корневой TRANSFER_CHAT

Что важно по текущему состоянию:
- в v1.2.48 в Settings добавлена проверка кэша UI: видно текущий загруженный bundle, bundle из актуального HTML на роутере и статус совпадения/рассинхрона
- в v1.2.48 кнопка жёсткого обновления UI теперь не ограничивается обычным reload: UI снимает service worker registrations, очищает CacheStorage и только потом форсирует reload с cache-bust query
- в v1.2.48 в Settings показывается frontend build stamp, а строка версии внизу левого меню сделана заметнее для быстрой визуальной проверки после обновления
- в v1.2.47 в разделе «Трафик» добавлен отдельный блок QoS runtime: видно состояние router-agent, safe mode `wan-only`, WAN/LAN rates и число IP, подтверждённых агентом
- в v1.2.47 строки «Трафика» показывают расширенный runtime по QoS/шейперу: подтверждение agent vs UI-only state, prio, гарантированный минимум и компактные IP/MAC подсказки
- в v1.2.45 подправлен масштаб графика `Router -> Трафик роутера -> live`: жёсткий минимум шкалы 1 MB/s визуально прятал малый live-трафик, поэтому теперь шкала адаптивно опускается до 64/128/256 KB/s и небольшие WAN-дельты больше не выглядят как пустой график
- в v1.2.44 починен router-agent CGI query parser под BusyBox /bin/sh: прежняя bash-only подстановка `${val//...}` роняла `cmd=status`, `cmd=traffic_live` и другие endpoint'ы с `Bad substitution`, из-за чего UI показывал `Агент включён, но недоступен`, не выводил версию агента и не работал live-трафик роутера
- в v1.2.43 починен router-agent `traffic_live`: в agent была потеряна helper-функция `read_iface_counter()`, из-за чего live-график трафика роутера мог не получать WAN counters; теперь `Router -> Трафик роутера -> live` снова должен опрашиваться нормально
- в v1.2.43 online-проверка прошивки снова стала осмысленной: router-agent теперь делает best-effort check по официальным страницам Netcraze Ultra для каналов main/preview/dev и возвращает latest version + updateAvailable вместо одного только currentVersion
- в v1.2.43 версия router-agent вынесена в более заметное место UI: badge в карточке Router Agent и badges в Router -> System Info
- в v1.2.42 исправлен `router-agent traffic_live`: live-трафик роутера в разделе Router снова должен корректно рисоваться
- в v1.2.42 восстановлены helper-функции firmware/status в router-agent: снова должна отображаться версия прошивки, а firmware_check больше не падает пустотой
- в v1.2.42 в Router -> System Info добавлены поля `Версия агента` и `Версия на сервере`
- QoS и лимиты живут в разделе «Трафик»
- подтверждённая проблема последних релизов: кнопка «Применить» в QoS оставалась неактивной, потому что строка часто ещё не успевала получить IP/agent-runtime к моменту первичной отрисовки
- в v1.2.31 кнопка QoS больше не блокируется предварительной локальной проверкой наличия IP в строке
- при нажатии UI теперь сам делает повторный цикл: agent ready -> users-db pull -> refresh lan hosts/qos -> повторный резолв IP
- initial load на странице «Трафик» переведён в последовательный сценарий: сначала agent/users-db, затем QoS status, а не три параллельных вызова без ожидания
- в v1.2.31 убран дублирующий QoS-бейдж из колонки QoS: статус QoS остаётся только рядом с именем хоста
- в v1.2.31 строки в разделе «Трафик» теперь дополнительно подмешиваются из router-agent qos_status, поэтому применённый QoS не должен визуально пропадать после очистки site storage/local storage даже у тихих устройств
- обновление UI на роутере выполняется через встроенный механизм обновления интерфейса, не через git pull
- router-agent в этом релизе не менялся
- host QoS в разделе «Трафик» временно отключён UI-hotfix
  до исправления runtime-логики в router-agent: при включении QoS на хостах подтверждён обрыв сетевых соединений; отключение QoS в Трафике восстанавливает сеть

- v1.2.41 — router-agent QoS hotfix: host QoS переведён в safe mode `wan-only`, чтобы не вешать downlink shaping на LAN bridge (`br0`) и не ронять соединения; при rehydrate/install очищается legacy downlink QoS-хвост, UI в «Трафике» снова включает QoS с пометкой Safe QoS: только uplink/WAN; router-agent обновлён до 0.6.9

- в v1.2.32 раздел «Трафик» получил MAC-aware привязку строк: сохранённые лимиты/QoS и шейпер теперь лучше переживают смену DHCP-IP
- в v1.2.32 строки в «Трафике» дедуплицируются по saved limit owner/MAC, чтобы один и тот же ПК не появлялся и как старое имя, и как новый IP
- в v1.2.32 расчёт лимитов, QoS и статуса шейпера в «Трафике» опирается на effective IP строки и её saved owner, а не только на локальную label mapping

- в v1.2.33 раздел «Трафик» перестаёт трактовать групповые Source IP labels (CIDR/regex, например общий label `dhcp`) как отдельные устройства: такие pool/group строки больше не должны получать host-level QoS/лимиты
- в v1.2.33 host-level резолв имён/IP для «Трафика», QoS и лимитов использует только точные host mappings, а не общие CIDR/regex labels

- в v1.2.35 раздел «Трафик» окончательно исключает групповые Source IP labels вроде `dhcp` из host-level строк, резолва IP для QoS/лимитов и поиска limit owner: lease-pool псевдопользователи больше не должны зеркалить действия по отдельным адресам
- v1.2.36 — перевыпуск релиза после сбоя push: код изменений не получил, обновлены номер версии, transfer-метаданные и упаковка релиза
- v1.2.37 — в разделе «Трафик» reserved pseudo labels вроде `dhcp`/`arp` больше не считаются host identities даже если приехали как exact mappings; реальные устройства в таких случаях падают обратно на IP/hostname, а псевдостроки lease pool не должны зеркалить QoS/лимиты

- v1.2.38 — hardening для «Трафика»: централизован список reserved pseudo labels (`dhcp`, `arp`, `dnsmasq`), дедупликация строк усилена по цепочке owner/MAC/IP, а бейдж лимита канала теперь сверяет ожидаемое ограничение с фактически управляемыми agent shapers и показывает mismatch/reapply вместо ложного зелёного статуса
- v1.2.39 — в «Трафике» добавлен компактный runtime-summary по строке (QoS/шейпер), ручное обновление runtime прямо из строки и более честный Reapply только для fail/unknown/mismatch состояний; tooltip шейпера теперь показывает связанные IP строки для быстрой диагностики
