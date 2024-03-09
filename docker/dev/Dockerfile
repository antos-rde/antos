FROM  debian:bookworm AS deploy-env
ARG UNAME=ci
ARG UID=1000
ARG GID=1000

RUN apt-get update && apt-get --yes --no-install-recommends install \
    build-essential \
    make \
    libsqlite3-dev \
    cmake \
    zlib1g-dev \
    libreadline-dev \
    libssl-dev \
    autotools-dev \
    autoconf \
    libtool \
    curl \
    automake \
    libffi-dev \
    ca-certificates \
    unzip \
    libturbojpeg0-dev \
    libvncserver-dev \
    lua5.3

RUN RUSTUP_HOME=/opt/rust/rustup CARGO_HOME=/opt/rust/cargo bash -c 'curl https://sh.rustup.rs -sSf | sh -s -- -y'
RUN chmod -R 777 /opt/rust/
RUN apt-get update && apt-get --yes --no-install-recommends install \
    nodejs npm git wget libfuse2 fuse3

# cross build support
RUN dpkg --add-architecture armhf
RUN dpkg --add-architecture arm64
RUN apt-get update && apt-get --yes --no-install-recommends install \
    crossbuild-essential-armhf \
    crossbuild-essential-armhf \
    libsqlite3-0:arm64 zlib1g:arm64 libreadline8:arm64 libssl3:arm64 \
    libffi-dev:arm64 libturbojpeg0:arm64 libvncclient1:arm64 \
    libsqlite3-0:armhf zlib1g:armhf libreadline8:armhf libssl3:armhf \
    libffi-dev:armhf libturbojpeg0:armhf libvncclient1:armhf

RUN groupadd -g 1000 -o ci
RUN useradd -m -u 1000 -g 1000 -o -s /bin/bash ci
USER ci
WORKDIR /home/ci