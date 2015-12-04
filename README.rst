
==================================
rsyslog
==================================

In computing, syslog is a widely used standard for message logging. It permits separation of the software that generates messages, the system that stores them, and the software that reports and analyzes them.

Sample pillars
==============

Single rsyslog service

.. code-block:: yaml

    rsyslog:
      client:
        enabled: true
        format:
          name: TraditionalFormatWithPRI
          template: '"%pri-text%: %timegenerated% %HOSTNAME% %syslogtag%%msg:::drop-last-lf%\n"'

Read more
=========

http://www.rsyslog.com/
https://wiki.gentoo.org/wiki/Rsyslog
https://github.com/saz/puppet-rsyslog
