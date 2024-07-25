FROM  debian:bookworm AS deploy-env

RUN apt-get update && apt-get --yes --no-install-recommends install libsqlite3-0 zlib1g libreadline8 wget libssl3 libvncclient1 libturbojpeg0 openssh-client tar tree
RUN apt clean &&  rm -rf /var/lib/apt/lists/*
RUN mkdir /ulib
RUN cp -rf /lib/*-linux-*/libsqlite3*.so* /ulib
RUN cp -rf /lib/*-linux-*/libreadline*.so* /ulib
# RUN cp -rf /lib/*-linux-*/libncurse*.so* /ulib
RUN cp -rf /lib/*-linux-*/libz*.so* /ulib
RUN cp -rf /lib/*-linux-*/libcrypt*.so* /ulib
RUN cp -rf /lib/*-linux-*/libdl*.so* /ulib
RUN cp -rf /lib/*-linux-*/libm*.so* /ulib
RUN cp -rf /lib/*-linux-*/libpthread*.so* /ulib
RUN cp -rf /lib/*-linux-*/libssl*.so* /ulib
RUN cp -rf /lib/*-linux-*/libc*.so* /ulib
RUN cp -rf /lib/*-linux-*/libgcc*.so* /ulib
RUN cp -rf /lib/*-linux-*/ld*.so* /ulib
RUN cp -rf /lib/*-linux-*/libpcre*.so* /ulib
RUN cp -rf /lib/*-linux-*/libuuid*.so* /ulib
RUN cp -rf /lib/*-linux-*/libidn2*.so* /ulib
RUN cp -rf /lib/*-linux-*/libpsl*.so* /ulib
RUN cp -rf /lib/*-linux-*/libunistring*.so* /ulib
RUN cp -rf /lib/*-linux-*/libjpeg*.so* /ulib
RUN cp -rf /lib/*-linux-*/libvncclient*.so* /ulib
RUN cp -rf /lib/*-linux-*/librt*.so* /ulib
RUN cp -rf /lib/*-linux-*/libstdc*.so* /ulib

# vnc client support
RUN cp -rf /lib/*-linux-*/libgcrypt*.so* /ulib
RUN cp -rf /lib/*-linux-*/libsasl2*.so* /ulib
RUN cp -rf /lib/*-linux-*/liblzo2*.so* /ulib
RUN cp -rf /lib/*-linux-*/libgnutls*.so* /ulib
RUN cp -rf /lib/*-linux-*/libgpg-error*.so* /ulib
RUN cp -rf /lib/*-linux-*/libp11-kit*.so* /ulib
RUN cp -rf /lib/*-linux-*/libtasn1*.so* /ulib
RUN cp -rf /lib/*-linux-*/libnettle*.so* /ulib
RUN cp -rf /lib/*-linux-*/libhogweed*.so* /ulib
RUN cp -rf /lib/*-linux-*/libgmp*.so* /ulib
RUN cp -rf /lib/*-linux-*/libffi*.so* /ulib

# sshclient
RUN cp -rf /lib/*-linux-*/libselinux*.so* /ulib
RUN cp -rf /lib/*-linux-*/libresolv*.so* /ulib
RUN cp -rf /lib/*-linux-*/libgssapi_krb5*.so* /ulib
RUN cp -rf /lib/*-linux-*/libkrb5*.so* /ulib
RUN cp -rf /lib/*-linux-*/libk5crypto*.so* /ulib
RUN cp -rf /lib/*-linux-*/libcom_err*.so* /ulib
RUN cp -rf /lib/*-linux-*/libkrb5support*.so* /ulib
RUN cp -rf /lib/*-linux-*/libkeyutils*.so* /ulib

RUN mkdir /build
COPY build/ /build/
RUN mkdir /platform
RUN cp -rf /build/$(uname -m)/* /platform/

FROM busybox:1.36.1-glibc 
#copy all necessary libraries
COPY --from=deploy-env /ulib/ /lib/
COPY --from=deploy-env /bin/wget /bin/ 
COPY --from=deploy-env /usr/bin/ssh /bin/
COPY --from=deploy-env /usr/bin/ssh-keygen /bin/
COPY --from=deploy-env /usr/bin/ssh-copy-id /bin/
COPY docker/antos/profile /etc/profile
COPY --from=deploy-env /platform/opt/ /opt/

COPY docker/antos/start.sh /start.sh
RUN chmod 700 /start.sh
RUN chmod +x /opt/www/bin/*

ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/www/lib/"
ENV PATH="$PATH:/opt/www/bin/"
# start the entry point
ENTRYPOINT /start.sh
