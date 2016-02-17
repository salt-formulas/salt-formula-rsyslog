rsyslog:
  client:
    enabled: true
    format:
      name: TraditionalFormatWithPRI
      template: '"%pri-text%: %timegenerated% %HOSTNAME% %syslogtag%%msg:::drop-last-lf%\n"'

