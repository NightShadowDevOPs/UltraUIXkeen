# Chat transfer workflow — UI Mihomo / Ultra

1. Перед следующим чатом считать актуальной базой `v1.2.149`.
2. Проверять не только UI, но и то, что router traffic/runtime не пострадали.
3. Если обсуждение касается нагрузки на роутер, в первую очередь смотреть на lazy refresh, short TTL cache, request dedupe и safe fallback, а не на расширение постоянного polling.
4. Не предлагать `git pull` как основной способ обновления UI на роутере.
5. Если меняется `router-agent`, синхронизировать версии и документы.
