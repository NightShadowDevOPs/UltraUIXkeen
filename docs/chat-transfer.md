UI Mihomo / Ultra — обновление переноса v1.2.97

Что изменилось в этом релизе:
- structured editor `proxies` расширен на более редкие ветки, чтобы не держать `http-opts`, `smux`, часть wireguard/hysteria2/tuic только в raw YAML
- добавлены отдельные form-блоки для `http-opts` (`method`, `path`, `headers`) и `smux` (`enabled`, `protocol`, `max-connections`, `min/max-streams`, `padding`, `statistic`)
- вынесены в отдельные поля частые wireguard-параметры: `ip`, `ipv6`, `private-key`, `public-key`, `pre-shared-key`, `mtu`, `reserved`, `workers`
- добавлены отдельные поля для частых `hysteria2`/`tuic` параметров: `up`, `down`, `obfs`, `obfs-password`, `congestion-controller`, `udp-relay-mode`, `heartbeat-interval`, `request-timeout`, `fast-open`, `reduce-rtt`, `disable-sni`
- список прокси теперь подсвечивает наличие `http-opts`, `smux`, wireguard/hysteria2/tuic параметров отдельными бейджами
- `router-agent` в этом релизе не менялся; линия остаётся `0.6.22`

Текущие версии:
- UI: v1.2.97
- v1.2.97: structured editor `proxies` расширен на `http-opts`, `smux` и частые поля wireguard/hysteria2/tuic; router-agent не менялся
- router-agent: 0.6.22

Что важно по интерфейсу:
- `Mihomo` остаётся отдельным рабочим разделом
- `Settings` держит только интерфейс, поведение и связанные настройки отображения
- safe managed-config flow сохранён: `draft / validate / apply / rollback / baseline / history`
- raw YAML-редактор не убирался: structured-блоки работают поверх текущего черновика и не ломают безопасный pipeline
- вкладка `Роутер` по-прежнему разбита на `Обзор / Трафик / Сеть`

Следующий логичный шаг:
- после v1.2.97 логично либо продолжать углублять structured editor `proxies` на совсем экзотические ветки и шаблоны по типам прокси, либо добавить отдельные type-aware формы/подсказки для конкретных proxy-типов (`vmess/vless/trojan/wireguard/hysteria2/tuic`)
