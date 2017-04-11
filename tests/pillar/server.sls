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
