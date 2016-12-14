{%- from "rsyslog/map.jinja" import global with context %}

{%- if global.enabled %}

rsyslog_packages:
  pkg.latest:
  - names: {{ global.pkgs }}

/etc/rsyslog.conf:
  file.managed:
  - source: salt://rsyslog/files/rsyslog.default.conf
  - template: jinja
  - mode: 0640
  - require:
    - pkg: rsyslog_packages

/etc/rsyslog.d/50-default.conf:
  file.absent:
  - require:
    - pkg: rsyslog_packages

rsyslog_service:
  service.running:
  - enable: true
  - name: rsyslog
  - watch:
    - file: /etc/rsyslog.conf

{% if global.manage_file_perms is defined and global.manage_file_perms == true %}
{% for output,type in global.output.file.iteritems() %}
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
{% endif %}

{%- endif %}
