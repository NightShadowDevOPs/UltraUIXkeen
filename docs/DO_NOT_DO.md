# Do not do

Project: UI Mihomo Ultra / zash-agent
Release: v1.2.181
Title: Agent Maintenance: backup retention and log rotation

- Do not use `127.0.0.1:9099` as the router-agent endpoint; current listener is `192.168.0.1:9099`.
- Do not assume `/etc/crontabs/root`; confirmed cron path is `/opt/var/spool/cron/crontabs/root`.
- Do not deploy agent scripts through UI updater.
- Do not delete `users-db.json`, `shapers.db`, provider SSL cache, or ha-cache.
- Do not restart Mihomo for maintenance/log retention.
