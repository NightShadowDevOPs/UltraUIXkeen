# UI Mihomo Ultra v1.2.195 — Mihomo core v1.19.25 canary tools

## Что сделано

Добавлен безопасный router-side набор для проверки обновления ядра Mihomo с текущего v1.19.24 до v1.19.25 без автоматической замены бинарника.

Релиз не меняет конфигурацию Mihomo, TUN, sniffing, QUIC, QoS, routing, router-agent, Home Assistant и SmartLife.

## Файлы

- `router-agent/mihomo-core-canary-v1.2.195.sh` — staged workflow: `check`, `stage`, `test`, `apply`, `rollback`.
- `router-agent/install-mihomo-core-canary-v1.2.195.sh` — установка helper-скрипта в `/opt/etc/mihomo/core-updates/`.
- `scripts/check-mihomo-core-v1.2.195.sh` — компактная read-only проверка текущего ядра/процесса/watchdog.

## Безопасность

- По умолчанию скрипт только читает состояние.
- `stage` скачивает и распаковывает кандидат в `/opt/etc/mihomo/core-updates/v1.19.25/mihomo`.
- `test` запускает проверку конфига staged-бинарником через `mihomo -t -d /opt/etc/mihomo`.
- `apply` требует явный токен `APPLY_MIHOMO_1_19_25`.
- `rollback` требует явный токен `ROLLBACK_MIHOMO`.
- Перед заменой текущий бинарник копируется в `/opt/etc/mihomo/core-updates/backups/`.

## Рекомендованный порядок

```sh
cd /opt/etc/mihomo
set +e
BASE=https://raw.githubusercontent.com/NightShadowDevOPs/UltraUIXkeen/main
D=/tmp/zash-mihomo-core-195
mkdir -p "$D"
curl -fsSL "$BASE/router-agent/mihomo-core-canary-v1.2.195.sh" -o "$D/mihomo-core-canary-v1.2.195.sh"
curl -fsSL "$BASE/router-agent/install-mihomo-core-canary-v1.2.195.sh" -o "$D/install-mihomo-core-canary-v1.2.195.sh"
chmod +x "$D"/*.sh
/opt/bin/sh "$D/install-mihomo-core-canary-v1.2.195.sh"
/opt/bin/sh /opt/etc/mihomo/core-updates/mihomo-core-canary-v1.2.195.sh stage
/opt/bin/sh /opt/etc/mihomo/core-updates/mihomo-core-canary-v1.2.195.sh test
```

Применение только после успешного `stage` и `test`:

```sh
/opt/bin/sh /opt/etc/mihomo/core-updates/mihomo-core-canary-v1.2.195.sh apply APPLY_MIHOMO_1_19_25
```

Rollback:

```sh
/opt/bin/sh /opt/etc/mihomo/core-updates/mihomo-core-canary-v1.2.195.sh rollback ROLLBACK_MIHOMO
```

## Проверка после применения

```sh
cd /opt/etc/mihomo
set +e
/opt/bin/sh /opt/etc/mihomo/core-updates/mihomo-core-canary-v1.2.195.sh check
API='http://192.168.0.1:9099/cgi-bin/api.sh'
for c in status mihomo_providers ha_snapshot; do echo -n "$c "; curl -sS -o /dev/null -m 15 -w "code=%{http_code} time=%{time_total}\n" "$API?cmd=$c"; done
```

## Наблюдение после обновления

Первый час не включать обратно sniffing и QUIC в браузерах. Сначала проверить обычный интернет, Telegram/мессенджеры, провайдеры, обновление подписок и Home Assistant Router Contract.
