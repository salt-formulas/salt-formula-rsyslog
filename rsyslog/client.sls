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

{%- if global.get('ssl', {'enabled': False}).enabled and global.get('ssl', {}).get('engine', 'salt') == 'manual' %}

{%- set ca_file=global.ssl.get('ca_file', '/etc/rsyslog.d/rsyslog_ca.crt') %}
{%- set key_file=global.ssl.get('key_file', '/etc/rsyslog.d/rsyslog_client.key') %}
{%- set cert_file=global.ssl.get('cert_file', '/etc/rsyslog.d/rsyslog_client.crt') %}

{%- if global.ssl.cert is defined %}

rsyslog_public_cert_client:
  file.managed:
  - name: {{ cert_file }}
  - contents_pillar: rsyslog:client:ssl:cert
  - owner: {{ global.run_user }}
  - group: {{ global.run_group }}
  - mode: 0400
  - require:
    - pkg: rsyslog_packages
  - watch_in:
    - service: rsyslog_service

{%- endif %}

{%- if global.ssl.key is defined %}

rsyslog_private_key_client:
  file.managed:
  - name: {{ key_file }}
  - contents_pillar: rsyslog:client:ssl:key
  - owner: {{ global.run_user }}
  - group: {{ global.run_group }}
  - mode: 0400
  - require:
    - pkg: rsyslog_packages
  - watch_in:
    - service: rsyslog_service

{%- endif %}

{%- if global.ssl.cacert_chain is defined %}

rsyslog_cacert_chain_client:
  file.managed:
  - name: {{ ca_file }}
  - contents_pillar: rsyslog:client:ssl:cacert_chain
  - owner: {{ global.run_user }}
  - group: {{ global.run_group }}
  - mode: 0400
  - require:
    - pkg: rsyslog_packages
  - watch_in:
    - service: rsyslog_service

{%- endif %}
{%- endif %}

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
