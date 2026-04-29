# Router-agent deploy notes — v1.2.176

## Router layout

Current known router layout:

- UI/Mihomo project path: `/opt/etc/mihomo`
- Installed agent runtime path: `/opt/zash-agent`
- Agent endpoint: `http://192.168.0.1:9099/cgi-bin/api.sh`
- Agent init script: `/opt/etc/init.d/S99zash-agent`

Do not assume `/opt/UltraUIXkeen` exists on this router.

## Apply command after release files are present

Run from the release directory that contains `scripts/` and `router-agent/`:

```sh
/opt/bin/sh scripts/apply-zash-agent-v1.2.176.sh
```

The script:

- backs up `/opt/zash-agent` to `/opt/zash-agent.backup-v1.2.176-<timestamp>.tar.gz`;
- stops only the current zash-agent `uhttpd` and CGI processes;
- runs the packaged `router-agent/install.sh`;
- starts the agent through the installer/init flow;
- runs `scripts/check-zash-agent-v1.2.176.sh`.

## Re-check command

```sh
/opt/bin/sh scripts/check-zash-agent-v1.2.176.sh
```

Expected markers:

```text
LISTEN_9099=true
STATUS_HTTP=200
STATUS_OK=true
HA_SNAPSHOT_HTTP=200
HA_SNAPSHOT_OK=true
MIHOMO_PROVIDERS_HTTP=200
```

## Rollback

```sh
/opt/bin/sh scripts/rollback-zash-agent-v1.2.176.sh
```

Optional explicit backup path:

```sh
/opt/bin/sh scripts/rollback-zash-agent-v1.2.176.sh /opt/zash-agent.backup-v1.2.176-YYYYMMDD-HHMMSS.tar.gz
```

Rollback only touches `/opt/zash-agent` and related zash-agent processes.
