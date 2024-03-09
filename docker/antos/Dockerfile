FROM  ubuntu:jammy AS deploy-env
ARG tag
COPY deps/ /

RUN dpkg -i /libssl1.1_1.1.1f-$(uname -m).deb
# manual install libssl1.1
RUN apt-get update && apt-get --yes --no-install-recommends install libsqlite3-0 zlib1g libreadline8 wget libvncclient1 libjpeg-turbo8 openssh-client tar tree
RUN apt clean &&  rm -rf /var/lib/apt/lists/*
RUN mkdir /ulib
RUN cp -rf /lib/*-linux-*/libsqlite3*.so* /ulib
RUN cp -rf /lib/*-linux-*/libreadline*.so* /ulib
RUN cp -rf /lib/*-linux-*/libncurse*.so* /ulib
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


# antos
RUN mkdir /platform
COPY antos-release/ /
RUN tar -xzf /build/$tag/AntOS_$(uname -m).tar.gz -C /platform/
RUN chown -R root:root /platform
RUN tree /platform
RUN ls -al /platform

FROM busybox:stable-glibc 
#copy all necessary libraries
COPY --from=deploy-env /ulib/ /lib/
COPY --from=deploy-env /bin/wget /bin/ 
COPY --from=deploy-env /usr/bin/ssh /bin/
COPY --from=deploy-env /usr/bin/ssh-keygen /bin/
COPY --from=deploy-env /usr/bin/ssh-copy-id /bin/
COPY bash /bin/bash
COPY profile /etc/profile
RUN chmod a+x /bin/bash
# copy backend
COPY --from=deploy-env /platform/ /
# copy frontend
COPY antd-config.ini /opt/www/antd-config.ini
COPY runner.ini /opt/www/runner.ini
RUN chmod 744 /opt/www/antd-config.ini
RUN chmod 744 /opt/www/runner.ini

COPY start.sh /start.sh
RUN chmod 700 /start.sh
# start the entry point
ENTRYPOINT /start.sh
