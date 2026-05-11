# Chat transfer

Проект: UI Mihomo Ultra / router-agent.
Релиз: v1.2.188 — Provider Links / Subscription-first SSL Metadata.

Продолжить с v1.2.188. Цель релиза — не сломать существующие проверки провайдеров и мягко разделить ссылки: подписка, публичная панель, SSH/local панель.

После доставки релиза в GitHub/UI выполнить на роутере raw installer:

```sh
cd /opt/etc/mihomo
set +e
BASE=https://raw.githubusercontent.com/NightShadowDevOPs/UltraUIXkeen/main
D=/tmp/zash-provider-links-188
mkdir -p "$D"
curl -fsSL "$BASE/router-agent/install-provider-links-hotfix.sh" -o "$D/install-provider-links-hotfix.sh"
/opt/bin/sh "$D/install-provider-links-hotfix.sh"
curl -fsSL "$BASE/scripts/check-provider-links-v1.2.188.sh" -o "$D/check.sh"
/opt/bin/sh "$D/check.sh"
```

Ожидаемо: `HAS_SSL_SOURCE=yes`, `HAS_PANEL_SSH_FIELD=yes`, watchdog `LAST_STATUS=OK`.
