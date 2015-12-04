{%- from "rsyslog/map.jinja" import common with context %}

rsyslog_packages:
  pkg.latest:
  - names: {{ common.pkgs }}

/etc/rsyslog/rsyslog.conf:
  file.managed:
  - source: salt://rsyslog/files/rsyslog.conf
  - template: jinja
  - mode: 640
  - group: rsyslog
  - require:
    - pkg: rsyslog_packages

rsyslog_service:
  service.running:
  - enable: true
  - name: rsyslog
  - watch:
    - file: /etc/rsyslog/rsyslog.conf

{%- endif %}
