
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

PLATFORM?=x86_64

RUSTUP_HOME?=/opt/rust
CARGO_HOME?=/opt/rust/cargo
RUST_TARGET?=x86_64-unknown-linux-gnu

DESTDIR?=$(ROOT_DIR)/build/
BUILD_PREFIX:=$(DESTDIR)/opt/www

VERSION?=2.0.0
BRANCH?=b
BUILDID=$(shell git rev-parse  --short HEAD)

VERSION_STR=$(VERSION)-$(BRANCH)-$(BUILDID)
PKG_NAME="AntOS_${VERSION_STR}_${PLATFORM}"

all: antos deb tar.gz appimg

antos: antd backend frontend

antd: httpd plugins luasec luasocket silk luafcgi
	rm $(BUILD_PREFIX)/runner.ini
	cp $(ROOT_DIR)/config/*.ini $(BUILD_PREFIX)/etc
	@echo "Finish building Antd server"

httpd:
	cd $(ROOT_DIR)/antd/ant-http && libtoolize && aclocal && autoconf && automake --add-missing
	cd $(ROOT_DIR)/antd/ant-http  && ./configure --prefix=$(BUILD_PREFIX)
	make -C $(ROOT_DIR)/antd/ant-http install

plugins: antd-fcgi-plugin antd-tunnel-plugin antd-wvnc-plugin antd-tunnel-publishers
	@echo "Finish making plugins"

luasec:
	@echo "Building $@"
	lua5.3 $(ROOT_DIR)/antd/luasec/src/options.lua -g \
		/usr/include/openssl/ssl.h \
		> $(ROOT_DIR)/antd/luasec/src/options.c
	INC_PATH=-I$(ROOT_DIR)/antd/silk/modules/lua/lua54/ \
		make -C $(ROOT_DIR)/antd/luasec linux
	INC_PATH=-I$(ROOT_DIR)/antd/silk/modules/lua/lua54/ \
		DESTDIR=$(DESTDIR) \
		LUAPATH=/opt/www/lib/lua \
		LUACPATH=/opt/www/lib/lua \
		make -C $(ROOT_DIR)/antd/luasec install

luasocket:
	@echo "Building $@"
	LUAV=5.4 \
		LUAINC_linux=$(ROOT_DIR)/antd/silk/modules/lua/lua54/ \
		LUAPREFIX_linux=$(DESTDIR) \
		PLAT=linux \
		make -C $(ROOT_DIR)/antd/luasocket linux
	LUAV=5.4 \
		LUAINC_linux=$(ROOT_DIR)/antd/silk/modules/lua/lua54/ \
		LUAPREFIX_linux=$(DESTDIR) \
		PLAT=linux \
		make -C $(ROOT_DIR)/antd/luasocket install-unix
	-mkdir -p $(DESTDIR)/lib/lua
	cp -rf $(DESTDIR)/lib/lua/5.4/* $(DESTDIR)/opt/www/lib/lua/
	cp -rf $(DESTDIR)/share/lua/5.4/* $(DESTDIR)/opt/www/lib/lua/
	rm -rf $(DESTDIR)/lib $(DESTDIR)/share

antd-% sil%: httpd
	@echo "Building $@"
	cd $(ROOT_DIR)/antd/$@ && libtoolize && aclocal && autoconf && automake --add-missing
	cd $(ROOT_DIR)/antd/$@  && CFLAGS="-I$(BUILD_PREFIX)/include" LDFLAGS="-L$(BUILD_PREFIX)/lib" ./configure --prefix=$(BUILD_PREFIX)
	make -C $(ROOT_DIR)/antd/$@ install

luafcgi:
ifeq ($(LUAFCGI_IGNORE),)
	@echo "Building $@"
	RUSTUP_HOME=$(RUSTUP_HOME) CARGO_HOME=$(CARGO_HOME) \
	. $(CARGO_HOME)/env && \
		rustup default stable && \
		rustup target add $(RUST_TARGET) && \
		cargo build --target=$(RUST_TARGET) --release \
		--manifest-path=$(ROOT_DIR)/antd/luafcgi/Cargo.toml
	install -m 0755 $(ROOT_DIR)/antd/luafcgi/target/$(RUST_TARGET)/release/luad $(BUILD_PREFIX)/bin
else
	@echo "Ignore building $@"
endif

clean:
	@echo "Clean all target"
	make -C antd/ant-http clean
	make -C antd/antd-fcgi-plugin clean
	make -C antd/antd-tunnel-plugin clean
	make -C antd/antd-wvnc-plugin clean
	make -C antd/antd-tunnel-publishers clean
	make -C antd/luasec clean
	make -C antd/luasocket clean
	make -C antd/silk clean
	RUSTUP_HOME=$(RUSTUP_HOME) CARGO_HOME=$(CARGO_HOME) \
	. $(CARGO_HOME)/env && cargo clean --manifest-path=$(ROOT_DIR)/antd/luafcgi/Cargo.toml
	-rm -rf $(DESTDIR)/*

backend:
	@echo "Building $@"
	DESTDIR=$(BUILD_PREFIX)/htdocs/os make -C antos-backend

frontend:
ifeq ($(FRONTEND_IGNORE),)
	@echo "Building $@"
	BUILDDIR=$(BUILD_PREFIX)/htdocs/os make -C antos-frontend install_dev release
else
	@echo "Ignore building $@"
endif

deb: antos
	-rm $(DESTDIR)/*.deb
	scripts/mkdeb.sh $(VERSION_STR) $(PLATFORM) $(DESTDIR)

tar.gz: antos
	-rm $(DESTDIR)/$(PKG_NAME).tar.gz
	cd $(DESTDIR)/ && tar cvzf  $(PKG_NAME).tar.gz opt

appimg: antos
	-rm $(DESTDIR)/*.AppImage
	scripts/mkappimg.sh $(PLATFORM) $(VERSION_STR) $(DESTDIR) $(ROOT_DIR)/antos-64.png

.PHONY: antd antos