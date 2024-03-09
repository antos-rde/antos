
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
TAG:=$(subst master,stable,$(subst refs/heads/,,$(shell git symbolic-ref -q HEAD)))

ARCH?=amd64
VERSION?=2.0.0-b

RUSTUP_HOME?=/opt/rust
CARGO_HOME?=/opt/rust/cargo
DESTDIR?=$(ROOT_DIR)/build/

ifeq ('$(ARCH)','amd64')
RUST_TARGET?=x86_64-unknown-linux-gnu
CC_PREFIX?=
HOST?=
endif

ifeq ('$(ARCH)','arm64')
RUST_TARGET?=aarch64-unknown-linux-gnu
CC_PREFIX?=aarch64-linux-gnu-
HOST?=--host=aarch64-linux-gnu
endif

ifeq ('$(ARCH)','arm')
RUST_TARGET?=armv7-unknown-linux-gnueabihf
CC_PREFIX?=arm-linux-gnueabihf-
HOST?=--host=arm-linux-gnueabihf
endif

CC:=$(CC_PREFIX)gcc
CXX:=$(CC_PREFIX)g++
BUILD_PREFIX:=/opt/www
INSTALL_DIR:=$(DESTDIR)/$(ARCH)/$(BUILD_PREFIX)

BUILDID:=$(shell git rev-parse  --short HEAD)

VERSION_STR=$(VERSION)-$(BUILDID)
PKG_NAME="AntOS_${VERSION_STR}_${ARCH}"

all: antos tar.gz

antos: antd backend frontend
	cp $(ROOT_DIR)/README.md $(INSTALL_DIR)/htdocs/os

antd: httpd plugins luasec luasocket silk luafcgi
	rm $(INSTALL_DIR)/runner.ini
	cp $(ROOT_DIR)/config/*.ini $(INSTALL_DIR)/etc
	rm $(INSTALL_DIR)/bin/ant-d $(INSTALL_DIR)/bin/runnerd
	@echo "Finish building Antd server"

httpd: clean_c
	cd $(ROOT_DIR)/antd/ant-http && libtoolize && aclocal && autoconf && automake --add-missing
	cd $(ROOT_DIR)/antd/ant-http  && ./configure $(HOST) --prefix=$(BUILD_PREFIX)
	DESTDIR=$(DESTDIR)/$(ARCH) make -C $(ROOT_DIR)/antd/ant-http install

plugins: antd-fcgi-plugin antd-tunnel-plugin antd-wvnc-plugin antd-tunnel-publishers
	@echo "Finish making plugins"

luasec: clean_c
	@echo "Building $@"
	lua5.3 $(ROOT_DIR)/antd/luasec/src/options.lua -g \
		/usr/include/openssl/ssl.h \
		> $(ROOT_DIR)/antd/luasec/src/options.c
	CC=$(CC) \
	INC_PATH=-I$(ROOT_DIR)/antd/silk/modules/lua/lua54/ \
		make -C $(ROOT_DIR)/antd/luasec linux
	CC=$(CC) \
	INC_PATH=-I$(ROOT_DIR)/antd/silk/modules/lua/lua54/ \
		DESTDIR=$(DESTDIR)/$(ARCH) \
		LUAPATH=/opt/www/lib/lua \
		LUACPATH=/opt/www/lib/lua \
		make -C $(ROOT_DIR)/antd/luasec install

luasocket: clean_c
	@echo "Building $@"
	sed -i 's/^CC_linux=/CC_linux?=/g' $(ROOT_DIR)/antd/luasocket/src/makefile
	sed -i 's/^LD_linux=/LD_linux?=/g' $(ROOT_DIR)/antd/luasocket/src/makefile
	CC_linux=$(CC) \
	LD_linux=$(CC) \
	LUAV=5.4 \
		LUAINC_linux=$(ROOT_DIR)/antd/silk/modules/lua/lua54/ \
		LUAPREFIX_linux=$(BUILD_PREFIX) \
		PLAT=linux \
		make -C $(ROOT_DIR)/antd/luasocket linux
	CC_linux=$(CC) \
	LD_linux=$(CC) \
	LUAV=5.4 \
		LUAINC_linux=$(ROOT_DIR)/antd/silk/modules/lua/lua54/ \
		LUAPREFIX_linux=$(BUILD_PREFIX) \
		PLAT=linux \
		DESTDIR=$(DESTDIR)/$(ARCH) make -C $(ROOT_DIR)/antd/luasocket install-unix
	-mkdir -p $(INSTALL_DIR)/lib/lua
	cp -rf $(INSTALL_DIR)/lib/lua/5.4/* $(INSTALL_DIR)/lib/lua/
	cp -rf $(INSTALL_DIR)/share/lua/5.4/* $(INSTALL_DIR)/lib/lua/
	rm -rf $(INSTALL_DIR)/lib/lua/5.4 $(INSTALL_DIR)/share

antd-% sil%: clean_c
	@echo "Building $@"
	cd $(ROOT_DIR)/antd/$@ && libtoolize && aclocal && autoconf && automake --add-missing
	cd $(ROOT_DIR)/antd/$@  && CFLAGS="-I$(INSTALL_DIR)/include" LDFLAGS="-L$(INSTALL_DIR)/lib" \
		./configure $(HOST) --prefix=$(BUILD_PREFIX)
	DESTDIR=$(DESTDIR)/$(ARCH) make -C $(ROOT_DIR)/antd/$@ install

luafcgi:
ifeq ($(LUAFCGI_IGNORE),)
	@echo "Building $@"
	mkdir -p $(INSTALL_DIR)/bin
	RUSTUP_HOME=$(RUSTUP_HOME) CARGO_HOME=$(CARGO_HOME) \
	. $(CARGO_HOME)/env && \
		rustup default stable && \
		rustup target add $(RUST_TARGET) && \
		cargo build --target=$(RUST_TARGET) --release \
		--manifest-path=$(ROOT_DIR)/antd/luafcgi/Cargo.toml \
		--config=$(ROOT_DIR)/antd/luafcgi/.cargo/config.toml
	install -m 0755 $(ROOT_DIR)/antd/luafcgi/target/$(RUST_TARGET)/release/luad $(INSTALL_DIR)/bin
else
	@echo "Ignore building $@"
endif

clean_c:
	@echo "Clean all C based modules"
	-make -C antd/ant-http clean
	-make -C antd/antd-fcgi-plugin clean
	-make -C antd/antd-tunnel-plugin clean
	-make -C antd/antd-wvnc-plugin clean
	-make -C antd/antd-tunnel-publishers clean
	-make -C antd/luasec clean
	-make -C antd/luasocket clean
	-make -C antd/silk clean

clean: clean_c
	@echo "Clean Rust project and output DIR"
	RUSTUP_HOME=$(RUSTUP_HOME) CARGO_HOME=$(CARGO_HOME) \
	. $(CARGO_HOME)/env && \
		rustup default stable && \
		cargo clean \
		--manifest-path=$(ROOT_DIR)/antd/luafcgi/Cargo.toml \
		--config=$(ROOT_DIR)/antd/luafcgi/.cargo/config.toml
	-rm -rf $(DESTDIR)/*

backend:
	@echo "Building $@"
	mkdir -p $(INSTALL_DIR)/htdocs/os
	DESTDIR=$(INSTALL_DIR)/htdocs/os make -C antos-backend

frontend:
ifeq ($(FRONTEND_IGNORE),)
	@echo "Building $@"
	mkdir -p $(INSTALL_DIR)/htdocs/os
	BUILDDIR=$(INSTALL_DIR)/htdocs/os make -C antos-frontend install_dev release
else
	@echo "Ignore building $@"
endif

deb:
	-rm $(DESTDIR)/$(ARCH)/*.deb
	scripts/mkdeb.sh $(VERSION_STR) $(ARCH) $(DESTDIR)/$(ARCH)

tar.gz: antos
	-rm $(DESTDIR)/$(ARCH)/$(PKG_NAME).tar.gz
	cd $(DESTDIR)/$(ARCH)/ && tar cvzf  $(PKG_NAME).tar.gz opt

appimg:
	-rm $(DESTDIR)/$(ARCH)/*.AppImage
	scripts/mkappimg.sh $(ARCH) $(VERSION_STR) $(DESTDIR)/$(ARCH) $(ROOT_DIR)/antos-64.png

.PHONY: antd antos