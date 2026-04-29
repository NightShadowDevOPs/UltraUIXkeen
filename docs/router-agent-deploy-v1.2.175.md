# Router-agent deploy notes — v1.2.175

## Router layout

Current known router layout:

- UI/Mihomo project path: `/opt/etc/mihomo`
- Installed agent runtime path: `/opt/zash-agent`
- Agent endpoint: `http://192.168.0.1:9099/cgi-bin/api.sh`
- Agent init script: `/opt/etc/init.d/S99zash-agent`

Do not assume `/opt/UltraUIXkeen` exists on this router.

## Why this patch exists

A normal UI/project deploy may not refresh `/opt/zash-agent` if the packaged `router-agent/install.sh` was not copied to the live project path. The agent therefore needs an explicit apply step from the release package.

## Apply command after release files are present

Run from the unpacked release directory that contains `scripts/` and `router-agent/`:

```sh
/opt/bin/sh scripts/apply-zash-agent-v1.2.175.sh
```

The script:

- backs up `/opt/zash-agent` to `/opt/zash-agent.backup-v1.2.175-<timestamp>.tar.gz`;
- stops only the current zash-agent `uhttpd` and CGI processes;
- runs the packaged `router-agent/install.sh`;
- starts the agent;
- prints process/listen/status/ha_snapshot smoke results.

## Re-check command

```sh
/opt/bin/sh scripts/check-zash-agent-v1.2.175.sh
```

## Expected status

```text
HTTP/1.1 200 OK
{"ok":true,...}
```

## Expected snapshot

```text
HTTP/1.1 200 OK
{"ok":true,"contract":"zash.ha.snapshot.bundle.v1",...}
```

## Rollback note

If something goes sideways, restore from the backup archive made by the apply script. Do this only manually and only after saving the current broken state/logs; blind rollback is how routers learn slapstick comedy.
