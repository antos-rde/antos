FROM  debian:bookworm AS deploy-env

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
    libjpeg62-turbo-dev \
    libvncserver-dev \
    lua5.3
ENV RUSTUP_HOME=/opt/rust/rustup
ENV CARGO_HOME=/opt/rust/cargo

RUN bash -c 'curl https://sh.rustup.rs -sSf | sh -s -- -y'
RUN . /opt/rust/cargo/env && rustup default stable
RUN chmod -R 777 /opt/rust/
RUN apt-get update && apt-get --yes --no-install-recommends install \
    nodejs npm git wget libfuse2 fuse3

# cross build support
RUN dpkg --add-architecture armhf
RUN dpkg --add-architecture arm64
RUN apt-get update && apt-get --yes --no-install-recommends install \
    crossbuild-essential-armhf \
    crossbuild-essential-arm64 \
    libsqlite3-dev:arm64 zlib1g-dev:arm64 libreadline-dev:arm64 libssl-dev:arm64 \
    libffi-dev:arm64 libjpeg62-turbo-dev:arm64 libvncclient1:arm64 \
    libsqlite3-dev:armhf zlib1g-dev:armhf libreadline-dev:armhf libssl-dev:armhf \
    libffi-dev:armhf libjpeg62-turbo-dev:armhf libvncclient1:armhf
RUN ln -sf /usr/lib/arm-linux-gnueabihf/libvncclient.so.1 /usr/lib/arm-linux-gnueabihf/libvncclient.so
RUN ln -sf /usr/lib/aarch64-linux-gnu/libvncclient.so.1 /usr/lib/aarch64-linux-gnu/libvncclient.so
#RUN ln -sf /usr/lib/arm-linux-gnueabihf/libjpeg.so.62 /usr/lib/arm-linux-gnueabihf/libjpeg.so
#RUN ln -sf /usr/lib/aarch64-linux-gnu/libjpeg.so.62 /usr/lib/aarch64-linux-gnu/libjpeg.so

RUN groupadd -g 1000 -o ci
RUN useradd -m -u 1000 -g 1000 -o -s /bin/bash ci
USER ci
WORKDIR /home/ci
