UltraUIXkeen — CURRENT CHAT TRANSFER NOTE

Current release snapshot: v1.2.115
Date: 2026-04-18
Project root: UltraUIXkeen
Server path: /opt/UltraUIXkeen
Stack: Vue 3 + TypeScript + router-agent shell/cgi on router

What was done in v1.2.115
- Added a shared safe polling composable for visible-only refresh loops.
- Switched SystemCard, AgentCard, Host QoS card, RouterHealth, UserTrafficStats, and Tasks live logs/upstream checks to safe polling.
- Shared provider/users DB sync stores now skip interval ticks while the tab is hidden.
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
- v1.2.116: continue traffic/operational UX cleanup and trim any remaining heavy polling or overloaded checks blocks with the new safe-polling base.
