# Bugs and issues

## Fixed / improved

- Previous `restart-agent.sh` manually killed scoped uhttpd/CGI and then used `S99zash-agent start`, but did not prefer `S99zash-agent restart`.

## Still known

- UI updater does not deliver `router-agent/` or `scripts/` files to router runtime.
- Agent runtime changes must use raw/manual installer path.
- Do not test restart unnecessarily while API is healthy unless applying this release intentionally.
