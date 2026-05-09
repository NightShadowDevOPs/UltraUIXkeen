# Tasks done

Project: UI Mihomo Ultra / zash-agent
Release: v1.2.181
Title: Agent Maintenance: backup retention and log rotation

- Confirmed watchdog cron runs every 120 seconds.
- Confirmed zash-agent endpoint `http://192.168.0.1:9099/cgi-bin/api.sh` is healthy.
- Diagnosed `/opt/zash-agent` bloat: 32 daily backups in `/opt/zash-agent/var/backups`, about 806 MB.
- Manually cleaned old backups, keeping last 7; runtime size reduced to about 154.7 MB.
- Manually rotated `agent.log` from about 49.1 MB to a small active log and a compressed 2.0 MB copy.
- Prepared maintenance release to automate the same policy safely.
