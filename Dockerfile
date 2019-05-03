FROM alpine:3.9

LABEL maintainer="TekinTian <tekintian@gmail.com>"

ARG SYSLOG_VERSION="3.20.1"
ARG BUILD_CORES=2
COPY src/* /tmp/

RUN sed -i -e 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories && \
    apk add --no-cache \
    glib \
    pcre \
    eventlog \
    openssl \
    tini \
    && apk add --no-cache --virtual .build-deps \
    curl \
    alpine-sdk \
    glib-dev \
    pcre-dev \
    eventlog-dev \
    openssl-dev \
    tzdata \
    && set -ex \
    && cd /tmp \
    && tar -zxC /tmp -f syslog-ng-${SYSLOG_VERSION}.tar.gz \
    && cd /tmp/syslog-ng-${SYSLOG_VERSION} \
    && ./configure -q --prefix=/usr \
    && make -j $BUILD_CORES \
    && make install \
    && cp /usr/share/zoneinfo/PRC /etc/localtime \
    && echo "PRC" > /etc/timezone \
    && rm -rf /tmp/* \
    && apk del --no-cache .build-deps \
    && mkdir -p /etc/syslog-ng /var/run/syslog-ng /var/log/syslog-ng

#COPY ./etc /etc/
COPY syslog-ng.conf startup.sh /app/

RUN chmod +x /app/startup.sh

VOLUME ["/var/log/syslog-ng", "/var/run/syslog-ng", "/etc/syslog-ng"]

EXPOSE 514/udp 601/tcp 6514/tcp

ENTRYPOINT ["tini", "--"]

CMD ["/bin/sh", "-c", "/app/startup.sh && exec /usr/sbin/syslog-ng -F -f /etc/syslog-ng/syslog-ng.conf"]
