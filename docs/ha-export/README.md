# HA export handoff

Этот пакет предназначен для соседнего проекта Home Assistant.

Внутри лежит согласованный черновик контракта для данных, которые нужно получить с роутера:
- operational status;
- traffic rollup;
- users summary;
- qos summary.

Источник данных предполагается такой:
- роутер / `router-agent` готовит snapshot;
- Home Assistant читает готовые лёгкие JSON-ответы или MQTT-публикации;
- UI и HA не парсят друг друга.

Главная мысль: **не дёргать тяжёлые shell-скрипты из HA на каждый запрос**.
