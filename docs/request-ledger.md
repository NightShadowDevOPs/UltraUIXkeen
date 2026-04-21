# Request ledger — UI Mihomo / Ultra

## 2026-04-21 — v1.2.165
- user asked to continue after upstream review and decide what is actually worth taking
- chosen direction: only low-risk UI hardening, no new polling experiments and no router-agent changes
- taken from the review:
  - `Прокси`: protect `proxiesRef` usage against early / empty ref states
  - `Соединения`: show a normal empty-state when the table has no rows
- deliberately rejected in this step:
  - anything that adds or reshapes polling
  - anything that touches provider SSL checks
  - anything that changes `router-agent -> HA` shape
  - anything that can interfere with live traffic/runtime behavior

## 2026-04-21 — v1.2.164
- user approved continuing immediately after `v1.2.163`
- safe follow-up direction chosen: inspect the remaining non-Tasks visibility/polling overlap candidates
- found and fixed the remaining wake-up overlap in `Overview -> Router Health`
- the card already had a viewport re-entry refresh watcher, so `useSafePolling` auto wake-up was disabled there
- required constraints preserved:
  - do not touch router-agent
  - do not change `router-agent -> HA` shape
  - do not risk live traffic path
  - keep docs and transfer files updated

## 2026-04-21 — v1.2.163
- user approved continuing immediately after `v1.2.162`
- safe follow-up direction chosen: audit other operational cards for duplicate visible-resume refreshes
- fixed overlap between local `watch(...active...)` refresh logic and helper-driven `useSafePolling` auto wake-up in:
  - `Router -> System`
  - `Router -> Router agent`
  - `Router -> Host QoS`
  - `Traffic / Users` QoS statistics
- required constraints preserved:
  - do not touch router-agent
  - do not change `router-agent -> HA` shape
  - do not risk live traffic path
  - keep docs and transfer files updated

## 2026-04-21 — v1.2.162
- user continued the project from the `v1.2.161` archive because the next release package was not actually received
- user described the missed release scope explicitly: restore the soft anti-burst behavior on `Задачи` when returning to a visible browser tab
- required scope:
  - avoid repeated identical refresh bursts for `router-agent` status
  - avoid repeated identical refresh bursts for `Живые логи`
  - avoid repeated identical refresh bursts for upstream check
  - keep normal polling unchanged
  - keep manual refresh unchanged
  - keep `router-agent -> HA` structure unchanged
- release docs must be updated and chat-transfer materials must be refreshed

## 2026-04-20 — working rules kept active
- all explanations and release notes for this project must be in Russian
- update documentation on every release
- copy a memory snapshot into the docs on every release
- do not risk the real traffic path for cosmetic optimizations
- keep the Overview traffic weights chart working normally
- do not break automatic SSL-certificate checks for providers
