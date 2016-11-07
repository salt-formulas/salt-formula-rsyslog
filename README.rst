
==================================
rsyslog
==================================

In computing, syslog is a widely used standard for message logging. It permits separation of the software that generates messages, the system that stores them, and the software that reports and analyzes them.

Sample pillars
==============

Rsyslog service with default logging template

.. code-block:: yaml

    rsyslog:
      client:
        enabled: true


Rsyslog service with precise timestamps, severity, facility.

.. code-block:: yaml

    rsyslog:
      client:
        enabled: true
        format:
          name: TraditionalFormatWithPRI
          template: '"%syslogpriority% %syslogfacility% %timestamp:::date-rfc3339% %HOSTNAME% %syslogtag%%msg:::sp-if-no-1st-sp%%msg:::drop-last-lf%\n"'
        logfiles:
          file:
            -/var/log/syslog:
              filter: *.*;auth,authpriv.none
              owner: syslog
              group: adm
              createmode: 0640
              umask: 0022
            /var/log/auth.log:
              filter: auth,authpriv.*
              owner: syslog
              group: adm
              createmode: 0640
              umask: 0022
            -/var/log/kern.log:
              filter: kern.*
              owner: syslog
              group: adm
              createmode: 0640
              umask: 0022
           -/var/log/mail.log:
              filter: mail.*
              owner: syslog
              group: adm
              createmode: 0640
              umask: 0022
            /var/log/mail.err:
              filter: mail.err
              owner: syslog
              group: adm
              createmode: 0640
              umask: 0022
            ":omusrmsg:*":
              filter: *.emerg
            "|/dev/xconsole":
              filter: "daemon.*;mail.*; news.err; *.=debug;*.=info;*.=notice;*.=warn":


Read more
=========

http://www.rsyslog.com/
https://wiki.gentoo.org/wiki/Rsyslog
https://github.com/saz/puppet-rsyslog
