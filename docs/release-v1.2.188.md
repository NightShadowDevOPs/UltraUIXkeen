# UI Mihomo Ultra v1.2.188 — Provider Links / Subscription-first SSL Metadata

## Scope

Router-agent/UI metadata release for provider management links.

## Что изменено

- `mihomo_providers` теперь может отдавать отдельное поле `panelSshUrl` из ручной карты `providerPanelSshUrls` в `/opt/zash-agent/var/users-db.json`.
- Для каждого провайдера явно добавлено `sslCheckSource: "subscription"` — основная проверка сертификата относится к адресу подписки, а не к публичной панели.
- Старое поле `panelUrl` сохранено без изменения: оно остаётся адресом панели через Интернет.
- `panelSslNotAfter` сохранён как диагностическое поле, чтобы не ломать старые проверки, но UI отдаёт приоритет сертификату подписки.
- В таблице провайдеров добавлены компактные кнопки-ссылки: `Подписка`, `Панель · Internet`, `Панель · SSH`.

## Безопасный переход

Новый `panelSshUrl` не участвует в router-side SSL-проверке: адреса вида `https://127.0.0.1:port/...` открываются с ПК пользователя через локальный SSH-forward и не должны проверяться роутером.

## Не трогалось

- Mihomo core.
- TUN.
- QoS/routing.
- provider subscription URLs.
- users-db правила пользователей/ограничений.
- SmartLife/Home Assistant, HA DB, Energy, boiler.

## Runtime install

Для router-agent hotfix используется raw/manual путь:

```sh
BASE=https://raw.githubusercontent.com/NightShadowDevOPs/UltraUIXkeen/main
D=/tmp/zash-provider-links-188
mkdir -p "$D"
curl -fsSL "$BASE/router-agent/install-provider-links-hotfix.sh" -o "$D/install-provider-links-hotfix.sh"
/opt/bin/sh "$D/install-provider-links-hotfix.sh"
```
