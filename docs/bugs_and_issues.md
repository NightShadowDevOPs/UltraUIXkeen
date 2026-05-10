# Bugs and issues v1.2.184

## Fixed / addressed

- UI показывал `1.2.181` после установки agent hotfix `v1.2.182`. Причина: старый frontend bundle/cache, а не состояние `restart-agent.sh`.

## Still possible

- Если файлы роутера уже обновлены, но браузер показывает старую версию, причина может быть в PWA/service worker/browser cache.
