# HA export bridge notes

## Current baseline
- рабочий контракт для Home Assistant: `zash.ha.snapshot.v1`
- предпочтительный ресурс: `ha_snapshot`
- актуальный router-agent baseline: `0.6.31`
- live-стенд для проверок: `http://192.168.0.1:9099/cgi-bin/api.sh`

## v1.2.141
- контракт и JSON-структура для Home Assistant **не менялись**
- релиз посвящён синхронизации docs / handoff и выгрузке накопленного проектного контекста
- текущий HA baseline остаётся на `ha_snapshot` + `router-agent 0.6.31`

## v1.2.140
- доведён install hotfix: embedded CGI внутри `router-agent/install.sh` синхронизирован с `api.sh`
- после переустановки agent на live-роутере команда `ha_snapshot` реально появляется и отвечает
- `status.version` и `status.serverVersion` сходятся на `0.6.31`

## v1.2.139
- добавлен агрегированный `ha_snapshot`
- пакет Home Assistant переведён на single-resource polling
- цель: уменьшить параллельную нагрузку на роутер со стороны HA
