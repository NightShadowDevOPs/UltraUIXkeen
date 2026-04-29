# Project memory — UI Mihomo / Ultra

## Current baseline
- UI prepared: **v1.2.173**
- router-agent: **0.6.33**
- Router IP: **192.168.0.1**
- Project path on router: `/opt/UltraUIXkeen`
- Agent path: `/opt/zash-agent`

## Recent release chain
- `v1.2.169` — HA export / router-to-HA contract stabilization.
- `v1.2.170` — compact/advanced split for `Трафик -> Пользователи`.
- `v1.2.171` — compact/advanced split for `Трафик -> Устройства`.
- `v1.2.172` — calmer service/empty states for traffic tables.
- `v1.2.173` — router-agent startup self-call hotfix after observed agent HTTP timeout.

## v1.2.173 operational note
Observed: direct CGI `cmd=status` worked, but HTTP access to `192.168.0.1:9099` timed out and UI did not show providers. Manual cleanup restored work. Patch removes internal HTTP self-calls and hardens process cleanup.

## Do not forget
- TUN is not needed for the current config.
- Provider SSL checks must remain intact.
- HA export contract must not drift without explicit coordination with the HA/SmartLife project.
- Commands for router should start with `clear`.
