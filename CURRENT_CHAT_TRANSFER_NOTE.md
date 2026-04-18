UltraUIXkeen — CURRENT CHAT TRANSFER NOTE

Current release snapshot: v1.2.118
Date: 2026-04-18
Project root: UltraUIXkeen
Server path: /opt/UltraUIXkeen
Stack: Vue 3 + TypeScript + router-agent shell/cgi on router

What was done in v1.2.118
- Fixed the `AgentCard` template scope bug that made `Router → Backups` look almost empty.
- The dedicated backup workspace added in v1.2.117 now actually renders its controls and history panels.
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
- v1.2.119: continue functional Traffic work: device/user linking, duplicate cleanup, and clearer QoS/profile actions directly from the Traffic workspace.
- v1.2.120: clean Router overview further after backup extraction and keep it as a short operational summary.
- v1.2.121: continue provider-focused operational polish without touching the working SSL auto-check path.
