FROM alpine:3.22.2

############################
# Metadata
############################
LABEL maintainer="Daniel Wydler" \
      org.opencontainers.image.authors="Daniel Wydler" \
      org.opencontainers.image.description="Up-to-date Selfoss, a multipurpose RSS reader, live stream, mashup, aggregation web application." \
      org.opencontainers.image.documentation="https://github.com/dwydler/selfoss-docker/blob/master/README.md" \
      org.opencontainers.image.source="https://github.com/dwydler/selfoss-docker" \
      org.opencontainers.image.title="wydler/selfoss" \
      org.opencontainers.image.url="https://github.com/dwydler/selfoss-docker"

############################
# Arguments & Environment
############################
ARG VERSION=2.19
ARG SHA256_HASH="e49c4750e9723277963ca699b602f09f9148e2b9f258fce6b14429498af0e4fc"

ENV GID=991 \
    UID=991 \
    CRON_PERIOD=15m \
    UPLOAD_MAX_SIZE=25M \
    LOG_TO_STDOUT=false \
    MEMORY_LIMIT=128M \
    TIMEZONE=UTC \
    LOGROTATE_RETENTION=31

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

############################
# Runtime Dependencies
############################
# https://forums.docker.com/t/run-crond-as-non-root-user-on-alpine-linux/32644
# https://github.com/gliderlabs/docker-alpine/issues/381
# https://github.com/inter169/systs/blob/master/alpine/crond/README.md
RUN apk add --no-cache \
        logrotate \
        busybox-suid \
        libcap \
        ca-certificates \
        s6 \
        su-exec \
        nginx \
        php82 \
        php82-fpm \
        php82-gd \
        php82-curl \
        php82-mbstring \
        php82-tidy \
        php82-session \
        php82-xml \
        php82-simplexml \
        php82-xmlwriter \
        php82-dom \
        php82-pecl-imagick \
        php82-pdo_mysql \
        php82-pdo_pgsql \
        php82-pdo_sqlite \
        php82-iconv \
        php82-tokenizer \
        php82-xmlreader

############################
# Selfoss Download (isolated layer)
############################
RUN apk add --no-cache --virtual .build-deps \
        wget \
        unzip \
    && wget -q https://github.com/fossar/selfoss/releases/download/${VERSION}/selfoss-${VERSION}.zip -P /tmp \
    && echo "${SHA256_HASH}  /tmp/selfoss-${VERSION}.zip" | sha256sum -c - \
    && unzip -q /tmp/selfoss-${VERSION}.zip -d / \
    && mkdir -p /selfoss/data \
    && rm -rf /tmp/* \
    && apk del .build-deps

############################
# Security Adjustments
############################
RUN setcap cap_setgid=ep /bin/busybox \
    && rm -rf /etc/logrotate.d/* \
    && rm -f /etc/crontabs/root

############################
# RootFS
############################
COPY rootfs /
RUN chmod +x /usr/local/bin/run.sh /services/*/run /services/.s6-svscan/*

############################
# Runtime
############################
VOLUME /selfoss/data
EXPOSE 8888
CMD ["run.sh"]