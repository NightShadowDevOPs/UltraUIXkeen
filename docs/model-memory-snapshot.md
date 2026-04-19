# UltraUIXkeen — Model memory snapshot

## What this file is
This is a practical snapshot of long-lived project context that was accumulated during previous work on UltraUIXkeen and related router / HA bridge tasks.

## How this memory should be used
- Use it as **working context**, not as the only source of truth.
- Before implementing the next release in a new chat, verify the actual state of:
  - repository files
  - current packaged release
  - router-agent version on the router
  - actual runtime behaviour on the router / in Home Assistant
- If memory and real project files disagree, **project files and runtime win**.

## Memory snapshot relevant to this project
- Project: **UI Mihomo / Ultra**, repo `NightShadowDevOPs/UltraUIXkeen`.
- Local folder used by the user: `Y:\Мой диск\Git\UltraUIXkeen`.
- Router path: `/opt/UltraUIXkeen`.
- Router update flow: user normally updates the UI through the UI itself; do not fall back to `git pull` on the router as the main path.
- Router-agent is installed / updated separately via `router-agent/install.sh`.
- If `router-agent` changes, version must be synced in `install.sh` and in the status API.
- Router commands in release messages should start with `clear`.
- Automatic SSL certificate checks for proxy providers must not be broken during optimisation or refactoring.
- Traffic / QoS / shaping remain a key focus area.
- Home Assistant bridge now uses a stable `ha_snapshot`-based contract and that contract should not be changed casually.
- The user prefers every release to include updated docs and transfer files, not only code changes.

## Current confirmed release baseline
- Current UI package in this folder: **v1.2.146**
- Current router-agent line expected with this package: **0.6.31**
- Current HA bridge rule: **JSON contract unchanged**

## Operator note for a new chat
When continuing in a new chat, start by checking the current repo contents and the actual router-agent/runtime state before planning the next version. Memory is a map, not the territory.
