{%- from "rsyslog/map.jinja" import server with context %}

include:
- rsyslog.common

/etc/rsyslog.d/10-remote.conf:
  file.managed:
  - source: salt://rsyslog/files/10-remote.conf
  - template: jinja
  - mode: 0640
  - watch_in:
    - service: rsyslog_service

