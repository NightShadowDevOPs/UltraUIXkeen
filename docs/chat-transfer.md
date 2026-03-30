## v1.2.107 — 2026-03-30
- Traffic / QoS UI now explains WAN-only shaping in plain language: the bandwidth cell shows `current total traffic` separately from the `uplink/WAN limit`, and the runtime hint warns that download/LAN can look higher than the configured cap without meaning the uplink shaper failed
- Mihomo `Config` editing is temporarily disabled in the workspace to reduce router CPU load; the page now shows a maintenance notice instead of mounting the heavy editor block
- router-agent was not changed in this release; line remains `0.6.22`
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
