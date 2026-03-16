# UI Mihomo/Ultra — перенос в новый чат

Проект: UI Mihomo/Ultra (форк Zashboard UI)
Репозиторий: messireL/ZashUIFork
Линейка версий: 1.1.x
Текущая версия архива: v1.1.109
router-agent: 0.5.54

Последний фикс в этом релизе:
- восстановлена SSL-проверка сертификатов в router-agent для `mihomo_providers` и `panelUrl`
- исправлена сломанная сборка UI (`TasksPage.vue` и дубли `checking` в i18n)
- список провайдеров снова получает `sslNotAfter` и `panelSslNotAfter` напрямую из agent

Ключевые особенности:
- отдельные пункты меню: Прокси и Прокси-провайдеры
- multi-cloud backup через rclone и router-agent
- cloud remotes из одного rclone.config через RCLONE_REMOTES
- cron backup на роутере работает через /opt/var/spool/cron/crontabs/root
- дополнительная диаграмма трафика в стиле Netcraze с разделением по цветам: общий WAN / Mihomo / вне Mihomo (например XKeen или другие VPN)
- у новой диаграммы трафика разведены более контрастные цвета легенды, чтобы серии не сливались
- обнаруженные дополнительные VPN/туннели выводятся на диаграмме отдельными сериями по интерфейсам, а активные хосты по живым соединениям Mihomo показываются отдельным стабильным списком под диаграммой, чтобы строки не скакали
- в блоке роутера есть проверка обновления прошивки по официальной странице Netcraze и уведомление о новой версии
- для дополнительных туннелей усилено распознавание WireGuard/OpenVPN и похожих интерфейсов
- в карточке роутера есть модель, прошивка, kernel, arch, Mihomo, XKeen, температура, load average 1/5/15m, свободная RAM и storage
- активный раздел в левом меню подсвечен
- SSL-проверка не должна скрывать список провайдеров; ошибки SSL показываются отдельно, а сами данные по сертификатам снова заполняются в agent

Что важно не ломать:
- рабочую логику активности провайдеров
- крестик у провайдера — только disconnect active sessions
- cloud/local restore backup
- поддержку RCLONE_CONFIG, RCLONE_REMOTES, RCLONE_PATH

Отложенные задачи:
- разобраться с отображением архивов в облачном проводнике
- продолжить доводку подсчёта трафика Сегодня у прокси-провайдерах
- при желании позже показать в UI отдельный статус/ошибки SSL probe по недоступным провайдерам

Настройки backup:
- RCLONE_CONFIG="/opt/etc/rclone.config"
- RCLONE_REMOTES="gdrive_secure,yadisk_secure"
- RCLONE_PATH="backup/Zash"

Быстрая проверка multi-cloud backup:
- /opt/zash-agent/backup.sh "gdrive_secure,yadisk_secure"
- tail -n 200 /opt/zash-agent/var/backup.last.log
- cat /opt/zash-agent/var/backup.last.json
