# Release plan v1.2.183

1. Обновить `package.json` до `1.2.183`.
2. Добавить release docs и transfer state.
3. Добавить read-only check script для проверки старых UI version strings на роутере.
4. Не менять Mihomo core/TUN/QoS/routing/provider SSL/users-db/shapers.
5. После push/update проверить installed assets: `OLD_181_FILES=0`, `NEW_183_FILES>0`.
