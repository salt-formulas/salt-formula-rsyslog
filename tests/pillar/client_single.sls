    rsyslog:
      client:
        enabled: true
        format:
          name: custom
          template: '"%syslogpriority% %syslogfacility% %timestamp:::date-rfc3339% %HOSTNAME% %syslogtag%%msg:::sp-if-no-1st-sp%%msg:::drop-last-lf%\n"'
