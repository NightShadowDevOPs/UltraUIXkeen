UI Mihomo / Ultra — обновление переноса v1.2.96

Что изменилось в этом релизе:
- в `Mihomo → Конфигурация → Structured editors` добавлен отдельный редактор `proxies`
- теперь common-поля самих прокси можно править в форме: `name`, `type`, `server`, `port`, `udp`, `tfo`, `network`, `dialer-proxy`, `interface-name`, `packet-encoding`
- отдельными блоками вынесены `TLS / Security / Reality`, `Auth / Identity`, а также transport helpers для `ws-opts`, `grpc-opts` и `plugin-opts`
- при переименовании прокси UI теперь обновляет ссылки на него внутри `proxy-groups` и прямые target в `rules`
- при отключении прокси UI показывает план последствий, чистит зависимости и безопасно переводит затронутые direct-target rules на `DIRECT`
- `router-agent` в этом релизе не менялся; линия остаётся `0.6.22`

Текущие версии:
- UI: v1.2.96
- v1.2.96: добавлен отдельный structured editor для `proxies`, чтобы common-параметры самих прокси тоже редактировались по полям, а не вручную в YAML; router-agent не менялся
- router-agent: 0.6.22

Что важно по интерфейсу:
- `Mihomo` остаётся отдельным рабочим разделом
- `Settings` держит только интерфейс, поведение и связанные настройки отображения
- safe managed-config flow сохранён: `draft / validate / apply / rollback / baseline / history`
- raw YAML-редактор не убирался: structured-блоки работают поверх текущего черновика и не ломают безопасный pipeline
- вкладка `Роутер` по-прежнему разбита на `Обзор / Трафик / Сеть`

Следующий логичный шаг:
- после v1.2.96 логично либо углублять structured editor `proxies` для более редких nested-протокольных веток (`http-opts`, `smux`, `wireguard`, `hysteria2`, `tuic`), либо уже делать формовый слой для оставшихся тяжёлых config-секций вокруг runtime/sniffer
