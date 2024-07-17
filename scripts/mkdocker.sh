#!/bin/bash

set -e
set -x

DOCKER_IMAGE=$1

if [ -z "$DOCKER_IMAGE" ]; then
    echo "Please provide <image>:<tag> as parameter"
    exit 1
fi

rm build/aarch64 build/armv7l build/x86_64 || true

list=$(ls build/)

platforms=

for item in $list; do
    case $item in
        amd64)
            platforms="$platforms,linux/amd64"
            ;;
        arm64)
            platforms="$platforms,linux/arm64/v8"
            ;;
        arm)
            platforms="$platforms,linux/arm/v7"
            ;;
        *)
            echo "Unkown architecture $item"
            exit 1
            ;;
    esac
done
platforms=${platforms##,}
echo "Building docker image for the following platforms: $platforms"
ln -sfn arm build/armv7l
ln -sfn arm64 build/aarch64
ln -sfn amd64 build/x86_64

docker buildx build \
    --platform "$platforms" \
    --tag "$DOCKER_IMAGE" \
    -f docker/antos/Dockerfile \
    --push \
    .