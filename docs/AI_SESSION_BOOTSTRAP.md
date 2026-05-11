# AI_SESSION_BOOTSTRAP — v1.2.187

Continue UI Mihomo Ultra / router-agent from v1.2.187.

Current issue addressed: HA Router Contract CPU was stuck at `50%` because `ha_snapshot.status.system.cpu_pct` used stale/fallback data while `cmd=status` reported live CPU.

v1.2.187 prepared a router-agent-only hotfix:

- runtime installer: `router-agent/install-ha-snapshot-cpu-hotfix.sh`
- check script: `scripts/check-zash-agent-snapshot-cpu-v1.2.187.sh`
- marker: `v1.2.187 ha_snapshot live CPU/load overlay`

Do not touch Home Assistant, HA DB, native Energy, SmartLife boiler, Mihomo core, TUN, QoS/routing, provider SSL, users-db or shapers.db unless explicitly requested.
## v1.2.190 bootstrap addition

Current accepted direction: panels will be hidden from Internet access later; provider rows keep subscription URL, public panel URL and SSH/local panel URL separately. v1.2.190 only improves the visual layout of that table.

