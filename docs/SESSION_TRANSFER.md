# SESSION_TRANSFER v1.2.192

This release is safe to hand off to another chat/session.

Release scope:

- UI-only provider table alignment.
- No runtime router-agent mutation.
- No HA or SmartLife changes.

Important behavior:

- `Панель · Internet` and `Панель · SSH` are metadata/navigation fields.
- The SSH panel URL is filled manually; there is no automatic SSH tunnel creation on the router.
- Hosting payment dates are filled manually per provider.
- SSL expiry should continue to use subscription certificate data.
