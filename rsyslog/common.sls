{%- from "rsyslog/map.jinja" import global with context %}

rsyslog_packages:
  pkg.latest:
  - names: {{ global.pkgs }}

{%- if not grains.get('noservices', False) %}
rsyslog_service:
  service.running:
  - enable: true
  - name: rsyslog
{% endif %}
