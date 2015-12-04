{%- if pillar.rsyslog is defined %}
include:
{%- if pillar.rsyslog.server is defined %}
- rsyslog.server
{%- endif %}
{%- if pillar.rsyslog.client is defined %}
- rsyslog.client
{%- endif %}
{%- endif %}
