#!/bin/bash

set -eo pipefail

if [ "$1" = "" ]; then
  COMMAND="/usr/sbin/asterisk -T -W -p -vvvdddf"
else
  COMMAND="$@"
fi

exec ${COMMAND}