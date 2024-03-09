#! /bin/bash

set -e
set -x
arch=$1
tag=$2
DIR=$3
logo=$4
[ -z "$arch" ] && echo "1. No architecture provided" && exit 1
[ -z "$tag" ] && echo "2. No version provided" && exit 1
[ -z "$DIR" ] && echo "3. No input dir provided" && exit 1
[ -z "$logo" ] && echo "4. No logo file provided" && exit 1
# download the appimagetools
echo "Downloading the appimage tools"
archname=x86_64
case $arch in
    amd64|x86_64)
        archname=x86_64
        ;;
    aarch64|arm64)
        archname=aarch64
        ;;
    armv7l|arm)
        archname=armhf
        ;;
    *)
        echo "Unkown architecture"
        exit 1
        ;;
esac
APP_IMG="/tmp/appimagetool.AppImage"
APP_RUNT="/tmp/runtime-$archname"
APP_DIR="/tmp/antos.AppDir"
NAME="AntOS_${tag}_${archname}"
[ -f "$APP_IMG" ] || wget --no-check-certificate -O $APP_IMG https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x $APP_IMG
[ -f "$APP_RUNT" ] || wget -O $APP_RUNT --no-check-certificate https://github.com/AppImage/AppImageKit/releases/download/continuous/runtime-$archname


[ -d "$APP_DIR" ] && rm -rf "$APP_DIR"

echo "Building app image for $arch"

mkdir -p "$APP_DIR"

cp -rf "$DIR/opt" "$APP_DIR"
rm -rf $APP_DIR/opt/www/include || true
rm -rf $APP_DIR/opt/www/etc/* || true

# antd-config
cat << "EOF" >> $APP_DIR/opt/www/etc/antd-config.ini
[SERVER]
# DONOT edit following options
plugins=./opt/www/lib/
plugins_ext=.so
# These options can be changed
tmpdir=/tmp/
database=/tmp/antos_db/
maxcon=500
backlog=5000
workers = 4
max_upload_size = 20000000
gzip_enable = 1
gzip_types = text\/.*,.*\/css.*,.*\/json.*,.*\/javascript.*
debug_enable = 0
# if SSL is enable on one port, one should specify
# the SSL cert and key files
# Example: self signed key
# openssl genrsa -des3 -passout pass:1234 -out keypair.key 2048
# openssl rsa -passin pass:1234 -in keypair.key -out server.key
# openssl req -new -key server.key -out server.csr
# openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
# ssl.cert=/opt/www/server.crt
# ssl.key=/opt/www/server.key
# ssl.cipher=ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256

[PORT:8888]
plugins = fcgi,tunnel,wvnc
# DONOT edit this option
htdocs=./opt/www/htdocs
# Edit this option to enable SSL
ssl.enable=0
; other config shoud be rules applied on this port
; For example the following rule will
; convert a request of type:
;   name.example.com?rq=1  
;TO:
;    example.com/name/?rq=1
; this is helpful to redirect many sub domains
; to a sub folder of the same server
; ^([a-zA-Z][a-zA-Z0-9]*)\.[a-zA-Z0-9]+\..*$ = /<1><url>?<query>
; Sytax: [regular expression on the original request]=[new request rule]
^/os/(.*)$ = /os/router.lua?r=<1>&<query>


[MIMES]
image/bmp=bmp
image/jpeg=jpg,jpeg
text/css=css
text/markdown=md
text/csv=csv
application/pdf=pdf
image/gif=gif
text/html=html,htm,chtml
application/json=json
application/javascript=js
image/png=png
image/x-portable-pixmap=ppm
application/x-rar-compressed=rar
image/tiff=tiff
application/x-tar=tar
text/plain=txt
application/x-font-ttf=ttf
application/xhtml+xml=xhtml
application/xml=xml
application/zip=zip
image/svg+xml=svg
application/vnd.ms-fontobject=eot
application/x-font-woff=woff,woff2
application/x-font-otf=otf
audio/mpeg=mp3,mpeg

[PLUGIN:fcgi]
name = fcgi
autoload = 1
file_type = lua
bin = ./opt/www/bin/luad
socket = unix:/tmp/fcgi.sock

[PLUGIN:tunnel]
autoload = 1
name = tunnel
hotlines = unix:/tmp/antd_hotline.sock
EOF

# runner
cat << "EOF" >> $APP_DIR/opt/www/etc/runner.ini
[vterm]
# Do not change these 2 options
exec = ./opt/www/bin/vterm
param = unix:/tmp/antd_hotline.sock
# change this to enable debug
debug = 0

# used only by tunnel to authentificate user
[tunnel_keychain]
exec = ./opt/www/bin/wfifo
param = unix:/tmp/antd_hotline.sock
param = keychain
param = /tmp/antunnel_keychain
param = r
debug = 1
EOF

# AppRun
cat << "EOF" >> $APP_DIR/AppRun
#!/bin/sh
set -e
echo "Runing AntOS"
W=$(realpath $1)
B=$(dirname $0)
cd $B
[ ! -d "$W" ] && echo "$W is not a directory" && exit 1
# start antd-tunnel service
if [ ! -f "$W/antd-config.ini" ]; then
    cp ./opt/www/etc/antd-config.ini $W/antd-config.ini
fi
[ ! -f "$W/runner.ini" ] && cp ./opt/www/etc/runner.ini $W/runner.ini
export LD_LIBRARY_PATH="$B/opt/www/lib/"
echo "Runing Antd in $B with configuration $W/antd-config.ini"
./opt/www/bin/antd $W/antd-config.ini >/dev/null 2>&1 | ( sleep 2 && ./opt/www/bin/runner $W/runner.ini >/dev/null 2>&1 &)
EOF

chmod +x $APP_DIR/AppRun
# desktop file
cat << "EOF" >> $APP_DIR/antos.desktop
[Desktop Entry]
Name=AntOS
Exec=antd
Icon=antos
Type=Application
Categories=Utility;
Terminal=true
EOF

cp "$logo" "$APP_DIR/antos.png"

$APP_IMG --runtime-file $APP_RUNT $APP_DIR "$DIR/$NAME.AppImage"