#! /bin/bash

set -e
set -x

TAG=$1
ARCH=$2
DIR=$3

[ -z "$TAG" ] && echo "Unknown version" && exit 1
[ -z "$ARCH" ] && echo "Unknown architecture" && exit 1
[ -z "$DIR" ] && echo "Unknown output dir" && exit 1

case $ARCH in
    amd64|x86_64)
        archname=amd64
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

case $TAG in
    master)
        echo "Ignore TAG $TAG"
        exit 0
        ;;
    *)
        ;;
esac

echo "build ANTOS deb package for version $TAG, architecture $ARCH"

NAME="AntOS_${TAG}_${archname}"
FILE="$NAME.deb"
TMP="/tmp/$NAME"
[ -d "$TMP" ] && rm -rf "$TMP"
mkdir -p "$TMP"

echo "Copying binaries of version $TAG, architecture $ARCH to $TMP"
cp "$DIR/opt"  "$TMP/" -rf
cd "$TMP"
mkdir DEBIAN

cat << EOF >> DEBIAN/control
Package: AntOS
Version: $TAG
Architecture: $archname
Depends: libsqlite3-0,zlib1g,libreadline8,libssl3,libvncclient1,libjpeg-turbo8 | libturbojpeg0 | libjpeg62-turbo
Maintainer: Dany LE <dany@iohub.dev>
Description: All-in-one AntOS web-based remote desktop environment
EOF
cat DEBIAN/control
cd ..
dpkg-deb --build "$TMP"
mv "$FILE" "$DIR/"

