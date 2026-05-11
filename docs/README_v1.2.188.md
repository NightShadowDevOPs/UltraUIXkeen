# README

Проект: UI Mihomo Ultra / router-agent.
Релиз: v1.2.188 — Provider Links / Subscription-first SSL Metadata.

Назначение релиза: мягкий переход от проверки/использования публичных адресов панелей к подпискам как основному источнику SSL-проверки, без ломки текущих provider/mihomo checks.

Ключевые изменения:
- адрес подписки остаётся `url`;
- адрес панели через Интернет остаётся `panelUrl`;
- новый ручной адрес панели через SSH/local forward — `panelSshUrl`;
- SSL-проверка провайдера помечается как `sslCheckSource=subscription`;
- `panelSslNotAfter` сохранён только как диагностическое поле.
