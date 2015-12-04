{%- if pillar.rsyslog is defined %}
include:
{%- if pillar.rsyslog.server is defined %}
- rsyslog.common
{%- endif %}
{%- if pillar.rsyslog.client is defined %}
- rsyslog.common
{%- endif %}
{%- endif %}
