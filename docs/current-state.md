# Current state — UI Mihomo / Ultra

## Release baseline
- UI package target for this release: **v1.2.148**
- Router-agent line confirmed for this package: **0.6.32**
- Repo: `NightShadowDevOPs/UltraUIXkeen`
- Local workspace: `Y:\Мой диск\Git\UltraUIXkeen`
- Router path: `/opt/UltraUIXkeen`
- Update path on router: through the UI updater (do **not** treat `git pull` as the main update path)

## What this package does
- `v1.2.148` is a router-safe traffic telemetry hotfix.
- Live traffic/QoS/LAN payloads are now short-term cached inside router-agent so the UI stops hammering the router with heavy parallel reads.
- Host QoS card now loads expensive live traffic only when the card is opened or when the page is focused on a concrete host/user.
- Main goal of the release: **do not worsen router traffic/runtime**, while keeping the **Overview traffic-weight chart** alive and feeding it with normal telemetry.
- HA bridge contract stays compatible; handoff examples are synced to router-agent `0.6.32`.

## Constraints to keep in mind
- Do not break provider SSL checks.
- Do not make the Traffic section heavier again without measuring the router impact.
- UI update on router still goes through the built-in updater, not through manual git workflow.
- If router-agent changes again, keep versions in `router-agent/install.sh`, status API, docs and HA handoff bundle aligned.
