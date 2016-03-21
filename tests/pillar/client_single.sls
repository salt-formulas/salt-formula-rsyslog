    rsyslog:
      client:
        enabled: true
        format:
          name: TraditionalFormatWithPRI
          template: '"%syslogpriority% %syslogfacility% %timestamp:::date-rfc3339% %HOSTNAME% %syslogtag%%msg:::sp-if-no-1st-sp%%msg:::drop-last-lf%\n"'
        file:
          owner: root
          group: root
          createmode: 0640
          umask: 0022

