UI Mihomo / Ultra — обновление переноса v1.2.92

Что изменилось в этом релизе:
- в `Mihomo → Конфигурация` добавлен отдельный structured DNS editor для частых списков и nested-блоков секции `dns`
- теперь через UI можно редактировать `default-nameserver`, `nameserver`, `fallback`, `proxy-server-nameserver`, `fake-ip-filter`, `dns-hijack`, `nameserver-policy` и `fallback-filter` без ручной правки YAML
- DNS editor работает поверх текущего черновика/редактора и не ломает safe managed-config flow
- для `nameserver-policy` поддержан удобный формат строк `ключ = значение` или `ключ = value1, value2`, а для `fallback-filter` вынесены частые поля `geoip / geoip-code / geosite / ipcidr / domain`
- `router-agent` в этом релизе не менялся; линия остаётся `0.6.22`

Текущие версии:
- UI: v1.2.92
- v1.2.92: в `Mihomo → Конфигурация` добавлен structured DNS editor для `default-nameserver / nameserver / fallback / proxy-server-nameserver / fake-ip-filter / dns-hijack / nameserver-policy / fallback-filter`
- router-agent: 0.6.22

Что важно по интерфейсу:
- `Mihomo` остаётся отдельным рабочим разделом
- `Settings` держит только интерфейс, поведение и связанные настройки отображения
- diff, диагностика операций, structured overview, last successful, quick editor `tun/dns`, новый DNS structured editor, `proxy-providers`, `proxy-groups`, `rule-providers`, `rules` и safe managed-config flow сохранены
- raw YAML-редактор не убирался: structured-блоки работают поверх текущего черновика и не ломают безопасный pipeline

Следующий логичный шаг:
- дальше логично либо сделать внутренние вкладки/навигацию уже внутри самого `Mihomo → Конфигурация`, либо расширять DNS-редактор на более редкие ветки (`nameserver-policy` advanced values, `fallback-filter` extras) и затем переходить к rule options / nested-настройкам `proxy-groups`
