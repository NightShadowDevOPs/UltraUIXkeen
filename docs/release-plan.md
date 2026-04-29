# Release plan — v1.2.176

## Goal

Ship a safe deploy-hardening patch for the `v1.2.175` zash-agent line after audit.

## Scope

In scope:

- concise checker `scripts/check-zash-agent-v1.2.176.sh`;
- scoped apply script `scripts/apply-zash-agent-v1.2.176.sh`;
- rollback helper `scripts/rollback-zash-agent-v1.2.176.sh`;
- explicit docs status for old `ha_snapshot` timeout: fixed in `v1.2.174`;
- formal release-docs ZIP package.

Out of scope:

- Mihomo core changes;
- TUN mode;
- provider list parsing logic changes;
- SSL provider checks changes;
- traffic/QoS logic changes;
- HA contract changes;
- changing runtime agent code beyond existing packaged `0.6.35`.

## Risk

Low-to-medium operational risk because applying the patch restarts `zash-agent`. Live traffic routing itself is not touched.

## Deployment gate

Deploy only if the operator accepts the scoped agent restart. Do not deploy as part of unrelated Mihomo/TUN/provider changes.

## Verification

Run after release files are present on router:

```sh
/opt/bin/sh scripts/check-zash-agent-v1.2.176.sh
```

Critical success criteria:

- `STATUS_HTTP=200`;
- `STATUS_OK=true`;
- `HA_SNAPSHOT_HTTP=200`;
- `HA_SNAPSHOT_OK=true`;
- `MIHOMO_PROVIDERS_HTTP=200`;
- `LISTEN_9099=true`.

## Rollback

```sh
/opt/bin/sh scripts/rollback-zash-agent-v1.2.176.sh
```

The rollback script restores the latest `/opt/zash-agent.backup-v1.2.176-*` backup, falling back to `/opt/zash-agent.backup-v1.2.175-*` if needed.
