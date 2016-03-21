
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
        file:
          owner: root
          group: root
          createmode: 0640
          umask: 0022


Read more
=========

http://www.rsyslog.com/
https://wiki.gentoo.org/wiki/Rsyslog
https://github.com/saz/puppet-rsyslog
