# zash-agent

Current packaged agent version: `0.6.35`

## v1.2.176 packaging note

No router traffic path, HA contract, provider SSL check, QoS, TUN or Mihomo core logic is changed in this package.

`v1.2.176` keeps the runtime agent code at `0.6.35` and adds release/application hardening around it:

- concise smoke checker: `scripts/check-zash-agent-v1.2.176.sh`;
- direct scoped apply script: `scripts/apply-zash-agent-v1.2.176.sh`;
- rollback helper: `scripts/rollback-zash-agent-v1.2.176.sh`;
- explicit docs status for the old `ha_snapshot` timeout issue: **fixed in v1.2.174**, not open.
