# UltraUIXkeen — Current state

## Release target
- UI package target for this release: **v1.2.145**
- Router-agent line confirmed for this package: **0.6.31**
- Home Assistant bridge contract: **frozen / do not change payload shape without explicit need**
- Current stable HA pull model: **single `ha_snapshot` poll + attribute split inside HA**

## What is confirmed right now
- Router and Home Assistant already exchange data correctly through `ha_snapshot`.
- The user confirmed that the metrics are coming in and the HA side was checked successfully.
- `v1.2.142` introduced HA-side freshness helpers without changing the transport contract.
- This `v1.2.145` package focuses on making diagnostics cards truly operational: full drill-in slices, sticky active state and no hidden rows behind Top N, while keeping the Home Assistant bridge contract unchanged.

## Current guardrails
- Do not casually change the HA JSON contract.
- Do not break automatic SSL certificate checks for providers.
- Do not switch back to router-side `git pull` as the default UI update flow.
- Keep docs / handoff files current in every release.
