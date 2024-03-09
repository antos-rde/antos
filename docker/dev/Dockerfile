FROM  ubuntu:jammy AS deploy-env

# manual install libssl1.1
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
    libjpeg-turbo8-dev \
    libvncserver-dev \
    lua5.3

RUN RUSTUP_HOME=/opt/rust/rustup CARGO_HOME=/opt/rust/cargo bash -c 'curl https://sh.rustup.rs -sSf | sh -s -- -y'
RUN chmod -R 777 /opt/rust/
RUN apt-get update && apt-get --yes --no-install-recommends install \
    nodejs npm git wget libfuse2 fuse3