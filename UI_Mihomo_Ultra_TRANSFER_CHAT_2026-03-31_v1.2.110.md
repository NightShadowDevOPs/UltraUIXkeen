UI Mihomo / Ultra — обновление переноса v1.2.110

Что изменилось в этом релизе:
- раздел `Mihomo` убран из роутерного UI и из боковой навигации
- старый путь `/mihomo` больше не открывает отдельный workspace, а редиректит на `Router`
- `Settings` больше не предлагают открыть Mihomo workspace и теперь ведут обратно к лёгкому router/runtime экрану
- это осознанный шаг по оптимизации: тяжёлый config workspace снят с роутерной версии до общей разгрузки проекта

Текущие версии:
- UI: v1.2.110
- router-agent: 0.6.24

Что важно по текущему состоянию:
- роутерный проект теперь фиксируется как лёгкая панель управления: `Overview`, `Router`, `Traffic`, `Connections`, `Logs`, `Hosts/Policies`, QoS/shaping и Mihomo runtime-данные
- весь тяжёлый Mihomo config workspace не участвует в роутерной навигации и не должен считаться активной частью продукта, пока не будет выполнена общая оптимизация CPU/polling/agent
- shaping уже умеет переключаться: `ifb -> wan-police(hashlimit) -> lan-egress`, а диагностика показывает `shaperDownlinkMode`, `shaperIfbReady`, `shaperPoliceReady`, `shaperPoliceBackend`

Следующий логичный шаг:
- идти в аудит polling/agent endpoints и вычищать лишнюю фоновую нагрузку, а не возвращать тяжёлый config UI на роутер
