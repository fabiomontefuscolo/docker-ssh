#!/bin/sh

DAEMON=sshd

if ! ls /etc/ssh/ssh_host_* 1> /dev/null 2>&1; then
    ssh-keygen -A
fi

stop() {
    echo "Received SIGINT or SIGTERM. Shutting down $DAEMON"
    pid=$(cat /var/run/$DAEMON/$DAEMON.pid)
    kill -SIGTERM "${pid}"
    wait "${pid}"
    echo "Done."
}

echo "Running $@"
if [ "$(basename $1)" == "$DAEMON" ]; then
    trap stop SIGINT SIGTERM
    $@ &
    pid="$!"
    mkdir -p /var/run/$DAEMON && echo "${pid}" > /var/run/$DAEMON/$DAEMON.pid
    wait "${pid}" && exit $?
else
    exec "$@"
fi

