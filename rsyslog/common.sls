{%- from "rsyslog/map.jinja" import client,server with context %}

{%- if server.enabled %}

rsyslog_packages:
  pkg.latest:
  - names: {{ server.pkgs }}

{{ server.configfile }}:
  file.managed:
  - source: salt://rsyslog/files/rsyslog.conf.{{ grains.os_family }}
  - template: jinja
  - mode: 0640
  - require:
    - pkg: rsyslog_packages

rsyslog_service:
  service.running:
  - enable: true
  - name: rsyslog
  - watch:
    - file: {{ server.configfile }}

{% for logfile in server.logfiles %}
{{ logfile }}:
  file.managed:
  - mode: {{ server.file.createmode }}
  - watch:
    - file: {{ server.configfile }}
{% endfor %}

{%- endif %}

