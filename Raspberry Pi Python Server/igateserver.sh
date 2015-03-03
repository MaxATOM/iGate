#!/bin/sh
# 
# Start / Shutdown script for iGateServer
#

DIR=$(cd $(dirname "$0"); pwd)

case "$1" in
  start)

    # Start iGateServer
    `which python` "${DIR}"/server.py &

    ;;
  stop)
    # Stop iGateServer
    if [ -f /var/run/igateserver.pid ]
    then
      `which kill` -HUP `cat /var/run/igateserver.pid`
      `which rm` /var/run/igateserver.pid
    fi

    ;;

  *)
    echo "Usage: $0 {start|stop}" >&2
    exit 1

    ;;

esac

exit 0
