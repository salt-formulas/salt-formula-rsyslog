
============
Heka Formula
============

Heka is an open source stream processing software system developed by Mozilla. Heka is a Swiss Army Knife type tool for data processing

Sample pillars
==============

Basic log shipper streaming decoded rsyslog's logfiles using amqp broker as transport.
From every message there is one amqp message and it's also logged to  rsyslog's logfile in RST format.

.. code-block:: yaml


    rsyslog:
      server:
        enabled: true
        input:
          rsyslog-syslog:
            engine: logstreamer
            log_directory: /var/log
            file_match: syslog\.?(?P<Index>\d+)?(.gz)?
            decoder: RsyslogDecoder
            priority: ["^Index"]
          rsyslog-auth:
            engine: logstreamer
            log_directory: /var/log
            file_match: auth\.log\.?(?P<Index>\d+)?(.gz)?
            decoder: RsyslogDecoder
            priority: ["^Index"]
        decoder:
          rsyslog:
            engine: rsyslog
            template: %TIMESTAMP% %HOSTNAME% %syslogtag%%msg:::sp-if-no-1st-sp%%msg:::drop-last-lf%\n
            hostname_keep: TRUE
            tz: Europe/Prague
        output:
          rabbitmq:
            engine: amqp
            host: localhost
            user: guest
            password: guest
            vhost: /logs
            exchange: logs
            exchange_type: fanout
            encoder: ProtobufEncoder
            use_framing: true
          rsyslog-logfile:
            engine: logoutput
            encoder: RstEncoder
            message_matcher: TRUE
        encoder:
          rsyslog-logfile:
            engine: RstEncoder


Heka acting as message router and dashboard.
Messages are consumed from amqp and sent to elasticsearch server.


.. code-block:: yaml


    rsyslog:
      server:
        enabled: true
        input:
          rabbitmq:
            engine: amqp
            host: localhost
            user: guest
            password: guest
            vhost: /logs
            exchange: logs
            exchange_type: fanout
            decoder: ProtoBufDecoder
            splitter: HekaFramingSplitter
          rsyslog-syslog:
            engine: logstreamer
            log_directory: /var/log
            file_match: syslog\.?(?P<Index>\d+)?(.gz)?
            decoder: RsyslogDecoder
            priority: ["^Index"]
          rsyslog-auth:
            engine: logstreamer
            log_directory: /var/log
            file_match: auth\.log\.?(?P<Index>\d+)?(.gz)?
            decoder: RsyslogDecoder
            priority: ["^Index"]
        decoder:
          rsyslog:
            engine: rsyslog
            template: %TIMESTAMP% %HOSTNAME% %syslogtag%%msg:::sp-if-no-1st-sp%%msg:::drop-last-lf%\n
            hostname_keep: TRUE
            tz: Europe/Prague
        output:
          elasticsearch01:
            engine: elasticsearch
            host: localhost
            port: 9200
            encoder: es_json
            message_matcher: TRUE
          dashboard01:
            engine: dashboard
            ticker_interval: 30
        encoder:
          es-json:
            engine: es-json
            message_matcher: TRUE
            index = logfile-%{%Y.%m.%d}

Read more
=========

* https://rsyslogd.readthedocs.org/en/latest/index.html
