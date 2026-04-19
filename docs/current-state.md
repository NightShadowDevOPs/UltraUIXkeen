# Current state — validated live on 2026-04-19

## Confirmed versions
- UI package target for this release: **v1.2.141**
- Router-agent on live router: **0.6.31**
- `status.serverVersion`: **0.6.31**
- HA contract: **`zash.ha.snapshot.v1`**
- Preferred HA resource: **`ha_snapshot`**

## Live checks already confirmed
### 1) Status
`wget -qO- "http://192.168.0.1:9099/cgi-bin/api.sh?cmd=status"`
- returns `ok: true`
- returns `version: 0.6.31`
- returns `serverVersion: 0.6.31`

### 2) Contract meta
`wget -qO- "http://192.168.0.1:9099/cgi-bin/api.sh?cmd=ha_contract_meta"`
- returns `agent_version: 0.6.31`
- returns `preferred_resource: ha_snapshot`
- returns commands list including `ha_snapshot`

### 3) Aggregated snapshot
`wget -qO- "http://192.168.0.1:9099/cgi-bin/api.sh?cmd=ha_snapshot"`
- returns one JSON bundle
- contains nested sections `status`, `traffic`, `users`, `qos`
- works after install/restart on the live router

### 4) Home Assistant side
- метрики поступают
- пользователь подтвердил, что интеграция работает

## Operational notes
- На первом прогреве или в редких моментах cache-warmup внутри snapshot могли всплывать нулевые значения в `traffic`, но прямой `ha_traffic` и повторный `ha_snapshot` подтверждали корректные данные.
- Для практической эксплуатации это означает: UI / HA должны учитывать, что `ha_snapshot` — это агрегат из короткоживущих cached-срезов, а не тяжёлый real-time stream.

## Release intent for v1.2.141
- Не трогать JSON-структуру для HA.
- Стабилизировать документный контур проекта.
- Зафиксировать roadmap следующего этапа без новых agent breaking changes.
