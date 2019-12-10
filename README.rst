
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
              user: syslog
              group: adm
              createmode: 0640
              umask: 0022
            /var/log/auth.log:
              filter: auth,authpriv.*
              user: syslog
              group: adm
              createmode: 0640
              umask: 0022
            -/var/log/kern.log:
              filter: kern.*
              user: syslog
              group: adm
              createmode: 0640
              umask: 0022
           -/var/log/mail.log:
              filter: mail.*
              user: syslog
              group: adm
              createmode: 0640
              umask: 0022
            /var/log/mail.err:
              filter: mail.err
              user: syslog
              group: adm
              createmode: 0640
              umask: 0022
            ":omusrmsg:*":
              filter: *.emerg
            "|/dev/xconsole":
              filter: "daemon.*;mail.*; news.err; *.=debug;*.=info;*.=notice;*.=warn":
           -/var/log/your-app.log:
              filter: "if $programname startswith 'your-app' then"
              user: syslog
              group: adm
              createmode: 0640
              umask: 0022
              stop_processing: true

Rsyslog service with RainerScript (module, ruleset, template, input).

.. code-block:: yaml

  rsyslog:
    client:
      run_user: syslog
      run_group: adm
      enabled: true
      rainerscript:
        module:
          imfile: {}
        input:
          imfile:
            nginx:
              File: "/var/log/nginx/*.log"
              Tag: "nginx__"
              Severity: "notice"
              Facility: "local0"
              PersistStateInterval: "0"
              Ruleset: "myapp_logs"
            apache2:
              File: "/var/log/apache2/*.log"
              Tag: "apache2__"
              Severity: "notice"
              Facility: "local0"
              Ruleset: "myapp_logs"
              PersistStateInterval: "0"
            rabbitmq:
              File: "/var/log/rabbitmq/*.log"
              Tag: "rabbitmq__"
              Severity: "notice"
              Facility: "local0"
              PersistStateInterval: "0"
              Ruleset: "myapp_logs"
        template:
          ImfileFilePath:
            parameter:
              type: string
              string: "<%PRI%>%TIMESTAMP:::date-rfc3339% %HOSTNAME% %syslogtag:1:32%%$.suffix%%msg:::sp-if-no-1st-sp%%msg%\n"
        ruleset:
          remote_logs:
            description: 'action(type="omfwd" Target="172.16.10.92" Port="10514" Protocol="udp" Template="ImfileFilePath")'
          myapp_logs:
            description: 'set $.suffix=re_extract($!metadata!filename, "(.*)/([^/]*[^/.log])", 0, 2, "all.log"); call remote_logs'

Rsyslog service with GNU TLS encryption for forwarding the messages (omfwd module with gtls network stream driver).

.. code-block:: yaml

  rsyslog:
    client:
      pkgs:
        - rsyslog-gnutls
        - rsyslog
      run_user: syslog
      run_group: adm
      enabled: true
      ssl:
        enabled: true
        engine: manual
        key: |
          -----BEGIN RSA PRIVATE KEY-----
          -----END RSA PRIVATE KEY-----
        cert: |
          -----BEGIN CERTIFICATE-----
          -----END CERTIFICATE-----
        cacert_chain: |
          -----BEGIN CERTIFICATE-----
          -----END CERTIFICATE-----
      rainerscript:
        global:
          defaultNetstreamDriverCAFile: "/etc/rsyslog.d/rsyslog_ca.crt"
          defaultNetstreamDriverKeyFile: "/etc/rsyslog.d/rsyslog_client.key"
          defaultNetstreamDriverCertFile: "/etc/rsyslog.d/rsyslog_client.crt"
      output:
        remote:
          somehost.domain:
            action: 'action(type="omfwd" Target="172.16.10.92" Port="20514" Protocol="tcp" streamDriver="gtls" streamDriverauthMode="anon" streamDriverMode="1")'
            filter: "*.*"
            enabled: true

Rsyslog service with RELP TLS encryption for forwarding the messages (omrelp module).

.. code-block:: yaml

  rsyslog:
    client:
      pkgs:
        - rsyslog-relp
        - rsyslog
      run_user: syslog
      run_group: adm
      enabled: true
      ssl:
        enabled: true
        engine: manual
        key: |
          -----BEGIN RSA PRIVATE KEY-----
          -----END RSA PRIVATE KEY-----
        cert: |
          -----BEGIN CERTIFICATE-----
          -----END CERTIFICATE-----
        cacert_chain: |
          -----BEGIN CERTIFICATE-----
          -----END CERTIFICATE-----
      rainerscript:
        module:
          omrelp: {}
      output:
        remote:
          somehost.domain:
            action: 'action(type="omrelp" target="172.16.10.92" port="20514" tls="on" tls.caCert="/etc/rsyslog.d/rsyslog_ca.crt" tls.myCert="/etc/rsyslog.d/rsyslog_client.crt" tls.myPrivKey="/etc/rsyslog.d/rsyslog_client.key" tls.authmode="name" tls.permittedpeer=["remote.example.com"])'
            filter: "*.*"
            enabled: true

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


Creates a new configuration file in the /etc/rsyslog.d/ directory
================

If necessary, creates a new configuration file with any content that your 
written in new config file - /etc/rsyslog.d/app.conf directory in the /etc/rsyslog.d directory

.. code-block:: yam

pillars:
  rsyslog:
    rsyslogd:
      rootsh.conf:
        content: |
          "if $programname == 'rootsh' then ~"

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
