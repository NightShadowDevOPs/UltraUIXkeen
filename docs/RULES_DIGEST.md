# Rules digest

Project: UI Mihomo Ultra / zash-agent
Release: v1.2.181
Title: Agent Maintenance: backup retention and log rotation

- Use universal release rules v9.10.2.
- Produce release, docs, and transfer packages.
- Do not use checkpoint-* artifact prefixes.
- Do not touch Mihomo core, TUN, QoS/routing, or provider SSL unless explicitly requested.
- Do not delete users-db/shapers/provider cache.
- Keep checks compact.
