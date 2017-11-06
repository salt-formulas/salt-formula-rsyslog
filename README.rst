
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
        output:
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
           -/var/log/your-app.log:
              filter: "if $programname startswith 'your-app' then"
              owner: syslog
              group: adm
              createmode: 0640
              umask: 0022
              stop_processing: true
              
RainerScript Support for module configuration
=============================================

In addition to support for the legacy format, `modules <http://www.rsyslog.com/doc/v8-stable/configuration/modules/index.html>`_ can be configured using the `RainerScript <http://www.rsyslog.com/doc/v8-stable/rainerscript/index.html>`_ format.

.. code-block:: yaml

    rsyslog:
      client:
        enabled: true
        rainerscript:
          imjournal:
            PersistStateInterval: 200
            StateFile: /run/systemd/journal/rsyslog
            IgnorePreviousMessages: on
        output
          file:
            -/var/log/syslog:
              filter: *.*;auth,authpriv.none
              owner: syslog
              group: adm
              createmode: 0640
              umask: 0022

Custom templates
================

It is possible to define a specific syslog template per output file instead of
using the default one.

.. code-block:: yaml

    rsyslog:
        output:
          file:
           /var/log/your-app.log:
              template: ""%syslogtag:1:32%%msg:::sp-if-no-1st-sp%%msg%\\n""
              filter: "if $programname startswith 'your-app' then"

Remote rsyslog server
=====================

It is possible to have rsyslog act as remote server, collecting, storing or forwarding logs.
This functionality is provided via rsyslog input/output modules, rulesets and templates.

.. code-block:: yaml

    rsyslog:
      server:
        enabled: true
        module:
          imudp: {}
        template:
          RemoteFilePath:
            parameter:
              type: string
              string: /var/log/%HOSTNAME%/%programname%.log
        ruleset:
          remote10514:
            description: action(type="omfile" dynaFile="RemoteFilePath")
        input:
          imudp:
            port: 10514
            ruleset: remote10514
          
  

Support metadata
================

If the *heka* support metadata is enabled, all output files are automatically
parsed by the **log_collector** service.
To skip the log_collector configuration, set the **skip_log_collector** to true.

.. code-block:: yaml

    rsyslog:
        output:
          file:
           /var/log/your-app.log:
              filter: "if $programname startswith 'your-app' then"
              skip_log_collector: true

Read more
=========

http://www.rsyslog.com/
https://wiki.gentoo.org/wiki/Rsyslog
https://github.com/saz/puppet-rsyslog

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-rsyslog/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-rsyslog

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
