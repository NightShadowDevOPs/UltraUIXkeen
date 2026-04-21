# UltraUIXkeen

## Current packaged snapshot

- UI: `v1.2.168`
- router-agent: `0.6.32`
- Focus: safe visible-resume cooldown for `Router -> System` without changes to `router-agent` / HA-export shape

**UltraUIXkeen** — веб-интерфейс для роутеров **Netcraze Ultra** (Entware + ядро **Mihomo**) с расширениями через `router-agent`.

Цель репозитория — дать удобный веб‑интерфейс для Mihomo на Ultra, обновления через GitHub Releases и расширенные функции через **router-agent** (то, чего нет в стандартном Clash/Mihomo API).

> ⚠️ В этом форке целевое окружение — **только Mihomo** (Ultra). Sing-box и прочие ядра здесь не поддерживаются.

<p align="center">
  <img src="./readme/pc.png" height="280">
  <img src="./readme/mobile.png" height="280">
</p>

---

## Что важно в v1.2.168

- `Router -> System`: быстрые hide/show вкладки и повторный visible-resume больше не должны подряд дёргать одинаковый status-refresh без паузы.
- Для карточки системной информации добавлен мягкий anti-burst cooldown на wake-up refresh, без изменений обычного polling cadence.
- Ручное обновление, загрузка деталей, `router-agent`, HA/export shape, SSL-проверки провайдеров и реальный traffic path не менялись.
- TUN оставлен вне релиза: проектная позиция сейчас — не включать его без отдельной реальной необходимости и без отдельного тестового сценария на роутере.

---

## Быстрый старт на роутере (Netcraze Ultra + Mihomo)

### 1) Подключить UI через Mihomo (rolling dist.zip)

Открой `/opt/etc/mihomo/config.yaml` и проверь/добавь настройки (пример):

```yaml
external-controller: 0.0.0.0:9090
secret: ""          # если используешь — укажи здесь и в UI

# Mihomo будет хранить UI в локальной папке (обычно ./ui)
external-ui: ui

# UI будет скачиваться из GitHub Release
external-ui-url: https://github.com/NightShadowDevOPs/UltraUIXkeen/releases/download/rolling/dist.zip
```

Перезапусти Mihomo.

Открытие UI обычно выглядит так:

`http://<router-ip>:9090/ui`

Если кеш мешает обновлению — можно временно добавить анти‑кэш:

`.../dist.zip?v=1730000000`

### 2) (Опционально) Установить router-agent (Entware)

Router-agent нужен для функций, которых нет в Mihomo API (например, shaping per‑client, бэкапы/восстановление и т.п.).

На роутере (Busybox wget не умеет https → используем `/opt/bin/wget`):

```sh
/opt/bin/wget -O- "https://raw.githubusercontent.com/NightShadowDevOPs/UltraUIXkeen/main/router-agent/install.sh" | sh
/opt/etc/init.d/S99zash-agent restart
```

Проверка статуса агента:

```sh
/opt/bin/wget -qO- "http://192.168.0.1:9099/cgi-bin/api.sh?cmd=status"
```

В UI: **Router → Router agent** → включить и указать URL:

`http://<router-ip>:9099`

Подробности: `router-agent/README.md`.

---

## Что умеет UltraUIXkeen

Фокус — удобство на **Ultra/Mihomo**:

- **Прокси → Провайдеры**: карточки провайдеров responsive (нормально масштабируются под ширину экрана).
- **Подписки**: отдельная вкладка для агрегированных клиентских подписок и QR-кодов (Mihomo/Clash и V2Ray/Xray), при этом трафик клиента идёт напрямую к серверам провайдеров.
- **Подписки**: можно указать публичную HTTPS-базу для опубликованного reverse proxy и собирать клиентские ссылки/QR уже из неё, а `format=json` умеет возвращать канонические публичные URL через `X-Forwarded-*`.
- **Прокси → Провайдеры**: настройка «показать/скрыть протоколы» (DIRECT/REJECT/VLESS/…)
  - сохранение (persist)
  - пресеты: «Показать всё», «Скрыть DIRECT+REJECT».
- Исправления UX (прозрачность/читаемость выпадающих меню).
- **Router-agent** (Entware): API для расширенных функций и **бэкапы** (в т.ч. в облако через rclone).
- **Router → QoS устройств**: заготовка приоритизации трафика для LAN-устройств (High / Normal / Low) через `tc` на роутере, без обязательных ручных правок в конфиге.
- Home Assistant export bundle остаётся совместимым: свежесть / stale-индикаторы для snapshot теперь считаются внутри HA template helpers, без изменения JSON payload от router-agent.
- Для переноса в новый чат и стабильной работы с проектом поддерживаются `docs/model-memory-snapshot.md`, `docs/project-memory.md`, `docs/request-ledger.md`, `docs/chat-transfer.md`.
- **Трафик**: рабочий экран разделён на режимы `Устройства` и `Пользователи`, чтобы отдельно видеть живые LAN-хосты/QoS и отдельно — лимиты, блокировки и накопленную статистику по правилам.
- **Router-agent / Home Assistant**: доступны лёгкие snapshot endpoint'ы `ha_contract_meta`, `ha_snapshot`, `ha_status`, `ha_traffic`, `ha_users`, `ha_qos`; новый `ha_snapshot` собирает bundle в одном JSON и помогает снизить число параллельных опросов из Home Assistant.
- **Home Assistant handoff**: в `docs/ha-export/homeassistant/` лежит готовый YAML bundle для быстрого подключения роутера в HA через REST + template sensors. Версионный sync в `status` и `ha_status` доведён до единообразного поведения, а основной HA bundle переведён на agent `0.6.32` с единым `ha_snapshot` resource.

---

## Обновления (как мы работаем)

1) ChatGPT готовит архив дистрибутива.
2) Денис распаковывает поверх локального репо → commit & push.
3) Роутер подтягивает UI из GitHub Release `rolling/dist.zip` через встроенный updater интерфейса.
4) В каждом релизе обновляются docs и файл переноса в новый чат.
