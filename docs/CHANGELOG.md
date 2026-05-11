# Changelog — v1.2.191

## Added
- Added manual hosting payment due-date field for each proxy provider in the provider checks table.
- Added payment status text: not set, today, expired, warning within 7 days, or OK with days left.
- Added persistence through shared users-db settings as `providerHostingDueDates` / `proxyProviderHostingDueDateMap`.

## Changed
- Provider access URL inputs are narrower to keep table columns aligned.
- Removing provider manual settings now also clears hosting payment due date for that provider.

## Not changed
- No router-agent runtime endpoint change.
- No Mihomo core, TUN, QoS, routing, provider SSL, users-db structure-breaking migration, or router reboot.
- SSL certificate checks continue to use subscription URL as the SSL source after v1.2.188.
