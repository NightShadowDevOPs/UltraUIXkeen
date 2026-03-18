# UI Mihomo/Ultra — перенос в новый чат

Проект: UI Mihomo/Ultra (форк Zashboard UI)
Репозиторий: messireL/ZashUIFork
Линейка версий: 1.2.x
Текущая версия архива: v1.2.1
router-agent: 0.6.1

Последний фикс в этом релизе:
- на вкладке `Подписки` добавлена настройка `Published HTTPS base`, чтобы собирать клиентские URL, QR и deeplink уже от нормального опубликованного HTTPS endpoint, а не только от локального LAN URL router-agent
- на карточках подписок теперь отдельно показываются локальные и опубликованные HTTPS URL; deeplink/QR предпочитают опубликованный HTTPS URL, если он задан
- `router-agent format=json` теперь понимает публикацию за reverse proxy через `X-Forwarded-Proto` / `X-Forwarded-Host` / `X-Forwarded-Prefix` и умеет возвращать канонические публичные URL в `request` / `urls`
- обновлены `docs/aggregated-subscriptions.md`, `router-agent/README.md`, `README.md`, `TRANSFER_CHAT` и `docs/chat-transfer.md` с примерами reverse proxy для Caddy/Nginx

Ключевые особенности:
- отдельные пункты меню: Прокси, Прокси-провайдеры и Подписки
- multi-cloud backup через rclone и router-agent
- cloud remotes из одного rclone.config через RCLONE_REMOTES
- cron backup на роутере работает через /opt/var/spool/cron/crontabs/root
- дополнительная диаграмма трафика в стиле Netcraze с разделением по цветам: общий WAN / Mihomo / VPN-туннели / bypass
- у новой диаграммы трафика разведены более контрастные цвета легенды, чтобы серии не сливались
- обнаруженные дополнительные VPN/туннели выводятся на диаграмме отдельными сериями по интерфейсам, а активные хосты по живым соединениям Mihomo показываются отдельным стабильным списком под диаграммой, чтобы строки не скакали
- в блоке роутера есть проверка обновления прошивки по официальной странице Netcraze и уведомление о новой версии
- для дополнительных туннелей усилено распознавание WireGuard/OpenVPN и похожих интерфейсов
- в карточке роутера есть модель, прошивка, kernel, arch, Mihomo, XKeen, температура, load average 1/5/15m, свободная RAM и storage
- активный раздел в левом меню подсвечен
- SSL-проверка не должна скрывать список провайдеров; ошибки SSL показываются отдельно, а сами данные по сертификатам снова заполняются в agent
- вкладка `Подписки` умеет отдавать клиентские агрегированные ссылки и QR-коды для Mihomo/Clash и V2Ray/Xray клиентов; сам клиент подключается напрямую к серверам провайдеров, а роутер только отдаёт подписку
- вкладка `Подписки` теперь умеет собирать те же ссылки через опубликованный HTTPS base URL, если router-agent опубликован за reverse proxy

Что важно не ломать:
- рабочую логику активности провайдеров
- крестик у провайдера — только disconnect active sessions
- cloud/local restore backup
- поддержку RCLONE_CONFIG, RCLONE_REMOTES, RCLONE_PATH
- новый сценарий Published HTTPS base на вкладке `Подписки`: локальный LAN URL остаётся для диагностики, а пользовательские ссылки должны уметь уходить на опубликованный HTTPS endpoint

Отложенные задачи:
- разобраться с отображением архивов в облачном проводнике
- продолжить проверку и доводку подсчёта трафика Сегодня у прокси-провайдеров, в первую очередь на длинных сессиях и пограничных кейсах
- при желании позже показать в UI отдельный статус/ошибки SSL probe по недоступным провайдерам
- следующий большой шаг по подпискам: проверить реальный HTTPS endpoint снаружи и решить, нужен ли отдельный JSON schema/endpoint под V2RayTun/Xray поверх текущего groundwork

Настройки backup:
- RCLONE_CONFIG="/opt/etc/rclone.config"
- RCLONE_REMOTES="gdrive_secure,yadisk_secure"
- RCLONE_PATH="backup/Zash"

Быстрая проверка multi-cloud backup:
- /opt/zash-agent/backup.sh "gdrive_secure,yadisk_secure"
- tail -n 200 /opt/zash-agent/var/backup.last.log
- cat /opt/zash-agent/var/backup.last.json

История последних релизов:
- UI v1.2.0 / agent 0.6.0: старт блока HTTPS subscriptions groundwork; на вкладке `Подписки` убрана ложная готовность V2RayTun и добавлено честное предупреждение про необходимость нормального HTTPS endpoint, а в `router-agent` появился подготовительный `format=json` endpoint с JSON manifest (providers + merged share links) как каркас под будущий HTTPS / Xray-поток.
- UI v1.2.1 / agent 0.6.1: добавлен сценарий `Published HTTPS base` на вкладке `Подписки`; клиентские URL/QR/deeplink теперь можно строить от опубликованного HTTPS endpoint, а `format=json` научился возвращать канонические публичные ссылки через `X-Forwarded-*`.
