# Project spec — UI Mihomo Ultra / router-agent

## Current provider access model
Each provider can have:
- subscription URL — used for subscription and SSL certificate source;
- public panel URL — legacy/Internet panel address for reference while panels are still public;
- SSH panel URL — manually entered browser URL such as `https://127.0.0.1:<port>/...` after panel is moved behind SSH tunnel;
- hosting payment due date — manually entered date in `YYYY-MM-DD` format.

## Important safety constraints
- Do not break current provider checks.
- Do not move panels behind SSH automatically.
- Do not open router SSH tunnels for provider panels.
- Do not touch Mihomo core, TUN, QoS/routing, users-db records beyond new optional settings, provider SSL checks, shapers, or router reboot.
