UltraUIXkeen — CURRENT CHAT TRANSFER NOTE

Current release snapshot: v1.2.116
Date: 2026-04-18
Project root: UltraUIXkeen
Server path: /opt/UltraUIXkeen
Stack: Vue 3 + TypeScript + router-agent shell/cgi on router

What was done in v1.2.116
- Split the Traffic page into two explicit work modes: Devices and Users.
- Moved live LAN/QoS triage into the Devices mode by surfacing Host QoS directly in Traffic.
- Kept accumulated traffic, limits, blocking, and user policy workflow isolated in the Users mode.
- Added normalized direct links via `?view=devices|users` for the Traffic workspace.
- router-agent version was not changed and stays 0.6.28.

Key context to keep in the next chat
- This is the router UI project, not the Ubuntu host project. Do not mix them.
- Router path: /opt/UltraUIXkeen.
- User updates UI on the router through the project’s own UI update flow, not via git pull on the router.
- Keep automatic SSL certificate checks for proxy providers intact; do not break or rewrite that subsystem casually.
- Config editing is not the priority right now; information architecture, traffic section, QoS/shaping, server/host state, providers, and operational UX matter more.
- In router command blocks always start with clear.
- In every release keep docs updated, including the transfer file for a new chat.

Recommended next step
- v1.2.117: continue functional traffic work: device/user linking, duplicate cleanup, and clearer QoS/profile actions directly from the Traffic workspace.
