# Changelog

## v1.2.124 — router workspace title polish
- page title bar now shows normal localized workspace names instead of exposing raw keys like `routerTraffic`
- added explicit labels for `Router → Overview / Backups / Traffic / Network`
- added explicit labels for `Traffic → Devices / Users`
- updated transfer docs and near-term release plan; router-agent version remains `0.6.26`

## v1.2.123 — router settings import build hotfix
- removed the dead import of `@/composables/useUISettings` from `RouterPage.vue`; the page now reads `showIPAndConnectionInfo` directly from `@/store/settings`, where this setting actually lives
- kept the `ConnectionInfoCard.vue` hotfix from v1.2.122 and finished the router page build chain so the route no longer depends on missing local wrappers or missing composables
- updated transfer docs and the near-term release plan after the second CI failure
- router-agent version did not change and remains `0.6.26`

## v1.2.122 — router network card build hotfix
- added the missing `src/components/router/ConnectionInfoCard.vue` wrapper used by `RouterPage.vue`, so production build no longer falls over on a phantom import
- restored the `Router → Network` workspace rendering by wiring it to the existing overview IP and latency widgets instead of referencing a file that did not exist
- updated transfer docs and the near-term release plan after the 1.2.121 build failure
- router-agent version did not change and remains `0.6.26`

## v1.2.121 — router overview cleanup and clearer work zones
- cleaned up `Router → Overview`: the page now starts with the live system summary and keeps `Backups`, `Traffic`, and `Network` as separate quick-access work cards instead of dumping everything into one long slab
- refactored `SystemCard` into a lighter operational snapshot with compact CPU/RAM/resource facts, while detailed router diagnostics and firmware checks stay collapsed and load only when opened
- kept backup workflow in its dedicated workspace, but made the overview act like a real cockpit again instead of a maintenance storage room with identity issues
- router-agent version did not change and remains `0.6.26`
