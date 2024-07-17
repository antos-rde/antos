
# BUILDING and INSTALLING AntOS

Work in progress

## Dependencies

### Build dependencies

```
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
    automake \
    libffi-dev \
    ca-certificates \
    unzip \
    libjpeg-turbo8-dev \
    libvncserver-dev \
    lua5.3 \
    nodejs npm \
    git wget curl 
```

### Rust

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
rustup default stable

Install cross toolchain

```
gcc-arm-linux-gnueabihf binutils-arm-linux-gnueabihf
gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu
```

Optional for  appImage

```
wget libfuse2 fuse3
```

### Runtime dependencies
```
libssl libsqlite3 zlib1g libreadline libvncclient1 libjpeg-turbo8 
```
## Build
```
git submodule update --init
CARGO_HOME=~/.cargo make

# build docker (WIP)
make docker

```