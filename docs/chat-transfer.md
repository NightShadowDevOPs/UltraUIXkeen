UI Mihomo / Ultra — обновление переноса v1.2.86

Что изменилось в этом релизе:
- быстрый редактор в `Mihomo → Конфигурация` расширен на частые scalar-поля секций `tun` и `dns`
- форма теперь умеет читать, preview-ить и записывать `tun.enable`, `tun.stack`, `tun.auto-route`, `tun.auto-detect-interface`, `dns.enable`, `dns.ipv6`, `dns.listen`, `dns.enhanced-mode`
- правки по-прежнему ограничены частыми scalar-ключами: списки `nameserver/fallback`, `dns-hijack` и другие сложные блоки YAML не пересобираются
- `router-agent` в этом релизе не менялся; линия остаётся `0.6.22`

Текущие версии:
- UI: v1.2.86
- router-agent: 0.6.22

Что важно по интерфейсу:
- `Mihomo` остаётся отдельным рабочим разделом
- `Settings` держит только интерфейс, поведение и связанные настройки отображения
- diff, диагностика операций, structured overview, last successful и safe managed-config flow сохранены

Следующий логичный шаг:
- после v1.2.86 можно либо идти в более умные формы для списков `dns/tun`, либо возвращаться к другим рабочим функциям Mihomo / Proxy / Traffic
