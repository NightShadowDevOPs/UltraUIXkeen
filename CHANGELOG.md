# Changelog

## v1.2.129 — backup workspace render hotfix
- fixed backup workspace render in `src/components/router/AgentCard.vue`: the archive inspection panel no longer references `item` outside the `v-for`, which could break the whole lazy-loaded backup block at runtime
- added template refs for the maintenance workspace and its first section so the “Загрузить” action can scroll to the loaded backup area more predictably
- router-agent is unchanged in this release and remains `0.6.26`

## v1.2.127 — backup workspace build hotfix
- fixed duplicate identifier in `src/components/router/AgentCard.vue` that broke production build for v1.2.126
- kept backup workspace loading logic and action flow intact, without touching proxy-provider SSL checks or router-agent behavior
- router-agent is unchanged in this release and remains `0.6.26`
