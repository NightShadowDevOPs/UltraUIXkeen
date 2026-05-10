# Project memory dump

Current known state before `v1.2.183`:
- Router Netcraze-5955 at `192.168.0.1`.
- zash-agent endpoint listens on `192.168.0.1:9099`, not `127.0.0.1`.
- zash-agent runtime marker `0.6.37`.
- Watchdog cron: `/opt/var/spool/cron/crontabs/root`, every 2 minutes.
- Maintenance cron: `/opt/var/spool/cron/crontabs/root`, daily 04:17.
- `/opt/zash-agent` reduced to about `154.7M` after retaining 7 backups and rotating agent.log.
- Restart helper `v1.2.182` installed with service restart preference.
