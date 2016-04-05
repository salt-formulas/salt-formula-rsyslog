{%- from "rsyslog/map.jinja" import client,server,common with context %}

{%- if common.enabled %}

rsyslog_packages:
  pkg.latest:
  - names: {{ common.pkgs }}

/etc/rsyslog.conf:
  file.managed:
  - source: salt://rsyslog/files/rsyslog.default.conf
  - template: jinja
  - mode: 0640
  - require:
    - pkg: rsyslog_packages

/etc/rsyslog.d:
  file.directory:
  - mode: 0755
  - require:
    - pkg: rsyslog_packages
  {% if common.purge_rsyslog_d is defined and common.purge_rsyslog_d == true %}
  - clean: true
  {% endif %}

{#
/etc/rsyslog.d/50-default.conf:
  file.managed:
  - source: salt://rsyslog/files/default.conf
  - template: jinja
  - mode: 0640
  - require:
    - file: /etc/rsyslog.conf
#}

rsyslog_service:
  service.running:
  - enable: true
  - name: rsyslog
  - watch:
    - file: /etc/rsyslog.conf

{% if common.manage_file_perms is defined and common.manage_file_perms == true %}
{% for output,type in common.output.file.iteritems() %}
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
