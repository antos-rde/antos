#! /bin/sh
if [ -f "/file.fs" ]; then
    mount /file.fs /home
fi

if [ -n "$ANTOS_USER" ]; then
    adduser --home "/home/$ANTOS_USER" --disabled-password --gecos "" "$ANTOS_USER"
    echo "$ANTOS_USER:$ANTOS_PASSWORD" | /bin/chpasswd
fi

unset ANTOS_USER
unset ANTOS_PASSWORD

# start syslog
syslogd -O /tmp/message

antd /opt/www/etc/antd-config.ini &
pid=$!
sleep 2
runner /opt/www/etc/runner.ini &
#pid_runner=$!

for signal in TERM USR1 HUP INT; do
  # shellcheck disable=SC2064
  trap "echo SIGNAL: $signal; kill -s $signal $pid" $signal
done

# USR2 converted to WINCH
# shellcheck disable=SC2064
trap "kill -s WINCH $pid" USR2

status=999
while true; do
  if [ "${status}" -le 128 ]; then
    # Status codes larger than 128 indicates a trapped signal terminated the wait command (128 + SIGNAL).
    # In any other case we can stop the loop. 
    break
  fi
  wait $pid
  status=$?
  echo exit status: $status
done