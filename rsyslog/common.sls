{%- from "rsyslog/map.jinja" import client,server with context %}

{%- if server.enabled %}

rsyslog_packages:
  pkg.latest:
  - names: {{ server.pkgs }}

/etc/rsyslog.conf:
  file.managed:
  - source: salt://rsyslog/files/rsyslog.conf.{{ grains.os_family }}
  - template: jinja
  - mode: 0640
  - require:
    - pkg: rsyslog_packages

/etc/rsyslog.d/50-default.conf:
  file.managed:
  - source: salt://rsyslog/files/default.conf
  - template: jinja
  - mode: 0640
  - require:
    - file: /etc/rsyslog.conf

rsyslog_service:
  service.running:
  - enable: true
  - name: rsyslog
  - watch:
    - file: /etc/rsyslog.conf

{% for output,type in server.output.file.iteritems() %}
{{ output }}:
  file.managed:
  - mode: "{{ type['createmode'] }}"
  - owner: {{ type['owner'] }}
  - group: {{ type['group'] }}
  - watch:
    - file: /etc/rsyslog.conf
  - watch_in:
    - service: rsyslog_service
{% endfor %}

{%- endif %}
