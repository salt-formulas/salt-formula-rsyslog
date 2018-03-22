{%- from "rsyslog/map.jinja" import global with context %}

include:
- rsyslog.common

{%- if global.enabled %}

/etc/rsyslog.conf:
  file.managed:
  - source: salt://rsyslog/files/rsyslog.default.conf
  - template: jinja
  - mode: 0640
  - require:
    - pkg: rsyslog_packages
  - watch_in:
    - service: rsyslog_service


/etc/rsyslog.d/50-default.conf:
  file.absent:
  - require:
    - pkg: rsyslog_packages
  - watch_in:
    - service: rsyslog_service

{%- for name, content in global.get('certs', {}).iteritems() %}

rsyslog_cert_{{ name | replace('/', '_') }}_client:
  file.managed:
  - name: {{ name }}
  - contents: {{ content | yaml_encode }}
  - owner: {{ global.run_user }}
  - group: {{ global.run_group }}
  - mode: 0400
  - require:
    - pkg: rsyslog_packages
  - watch_in:
    - service: rsyslog_service

{% endfor %}

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
