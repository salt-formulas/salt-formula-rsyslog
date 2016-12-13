# -*- coding: utf-8 -*-

import os


def syslog_file_match(output):
    """
    Return patterns to be used in logstreamer file_match config params.

    For example the function may return this dict:

    {
      "/var/log": "kern\.log|auth\.log|syslog|mail\.log|mail\.err"
    }
    """
    file_match = {}
    for name, config in output.get('file', {}).items():
        if not config.get('enabled', False):
            continue
        logdir = os.path.dirname(name)
        pattern = os.path.basename(name).replace('.', '\.')
        if logdir in file_match:
            file_match[logdir] = file_match[logdir] + '|' + pattern
        else:
            file_match[logdir] = pattern
    return file_match
