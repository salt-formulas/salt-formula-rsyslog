{%- from "rsyslog/map.jinja" import global with context %}

{%- if global.enabled %}

{% for key, val in pillar.rsyslog.rsyslogd.items() %}
rsyslog_{{key}}:
  file.managed:
    - name: /etc/rsyslog.d/{{key}}
    - contents: {{val.content}}
    - watch_in:
      - service: rsyslog

{%- endfor %}
{%- endif %}
