# UI Mihomo Ultra — transfer note v1.2.177

Актуальный релиз: v1.2.177.

Ключевой фикс: router-agent HA endpoints теперь защищены strict JSON wrapper от stdout leaks до HTTP headers.

Реальная раскладка роутера:
- проект/UI/Mihomo: `/opt/etc/mihomo`;
- установленный агент: `/opt/zash-agent`;
- init: `/opt/etc/init.d/S99zash-agent`;
- HTTP: `http://192.168.0.1:9099/cgi-bin/api.sh`.

Не менять без причины: TUN, Mihomo core, QoS/shaper semantics, provider SSL checks, HA contract shape.
