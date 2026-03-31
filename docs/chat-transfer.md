## v1.2.110 — 2026-03-31
- removed the `Mihomo` section from router UI navigation and routing; the old path now redirects to `Router`
- stopped positioning the router build as a Mihomo config workspace and updated Settings to point to the lightweight router/runtime view instead
- current router focus is optimization: traffic, QoS/shaping, host policies, Mihomo runtime status, and lightweight diagnostics stay in scope; heavy config editing stays out

## v1.2.109 — 2026-03-30
- router-agent updated to `0.6.24`
- when IFB is unavailable, hard per-host bandwidth shaping now falls back to a real forwarded WAN→LAN limiter via `iptables hashlimit` instead of only legacy `LAN egress` shaping
- agent `status` and `qos_status` now also expose `shaperPoliceReady` and `shaperPoliceBackend`, so diagnostics clearly show whether the router is in `ifb`, `wan-police`, or `lan-egress` mode
- Mihomo `Config` editing remains disabled in the UI to keep router CPU load down
- refreshed transfer docs for the next chat handoff

## v1.2.108 — 2026-03-30
- router-agent updated to `0.6.23`
- hard per-host bandwidth shaping now prefers `IFB ingress redirect` for downlink, so limits can clamp the real download path instead of only showing a nicer UI explanation
- if IFB is unavailable, the agent falls back to legacy `LAN egress` shaping instead of failing completely
- agent `status` and `qos_status` now expose `shaperDownlinkMode`, `shaperConfiguredMode`, `shaperIfbDevice`, and `shaperIfbReady` for diagnostics
- Mihomo `Config` editing remains disabled in the UI to keep router CPU load down
- refreshed transfer docs for the next chat handoff

UI Mihomo / Ultra — обновление переноса v1.2.106

Что изменилось в этом релизе:
- релиз `v1.2.106` не добавляет новую фичу, а чинит production build после `v1.2.105`
- в `MihomoConfigEditor.vue` исправлены недостающие закрывающие теги в секции `proxy-providers`, из-за которых Vue/Vite падали на `Element is missing end tag`
- сохранены изменения `v1.2.105`: сценарный мастер создания `proxies` и проверка обязательных полей перед шагом `Проверка`
- `router-agent` в этом релизе не менялся; линия остаётся `0.6.22`

Текущие версии:
- UI: v1.2.106
- v1.2.106: build-fix для `MihomoConfigEditor.vue`; устранено падение сборки на секции `proxy-providers`; router-agent не менялся
- router-agent: 0.6.22

Что важно по интерфейсу:
- `Mihomo` остаётся отдельным рабочим разделом
- `Settings` держит только интерфейс, поведение и связанные настройки отображения
- safe managed-config flow сохранён: `draft / validate / apply / rollback / baseline / history`
- raw YAML-редактор не убирался: structured-блоки работают поверх текущего черновика и не ломают безопасный pipeline
- вкладка `Роутер` по-прежнему разбита на `Обзор / Трафик / Сеть`

Следующий логичный шаг:
- после `v1.2.106` можно спокойно продолжать развитие мастеров/structured-редакторов, уже без текущей build-мины в `proxy-providers`
