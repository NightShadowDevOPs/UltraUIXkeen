# Backup notes — v1.2.180

Backup script path in release archive:

`scripts/backup-zash-agent-v1.2.180.sh`

The script creates a lightweight backup under:

`/opt/zash-agent.backup-v1.2.180-<timestamp>`

It copies only selected installed agent files required for rollback:

- `/opt/zash-agent/agent.env`
- `/opt/zash-agent/start.sh`
- `/opt/zash-agent/ssl-refresh.sh`
- `/opt/zash-agent/www/cgi-bin/api.sh`
- `/opt/etc/init.d/S99zash-agent`

It does not stop services, does not delete files and does not print secret values.
