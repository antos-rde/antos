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
sleep 2
runner /opt/www/etc/runner.ini &

cat