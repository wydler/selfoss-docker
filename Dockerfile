FROM alpine:3.22.2

LABEL maintainer="Daniel Wydler"
LABEL org.opencontainers.image.authors="Daniel Wydler"
LABEL org.opencontainers.image.description="Up-to-date Selfoss, a multipurpose RSS reader, live stream, mashup, aggregation web application. "
LABEL org.opencontainers.image.documentation="https://github.com/dwydler/selfoss-docker/blob/master/README.md"
LABEL org.opencontainers.image.source="https://github.com/dwydler/selfoss-docker"
LABEL org.opencontainers.image.title="wydler/selfoss"
LABEL org.opencontainers.image.url="https://github.com/dwydler/selfoss-docker"


ARG VERSION=2.19
ARG SHA256_HASH="e49c4750e9723277963ca699b602f09f9148e2b9f258fce6b14429498af0e4fc"

ENV GID=991 UID=991 CRON_PERIOD=15m UPLOAD_MAX_SIZE=25M LOG_TO_STDOUT=false MEMORY_LIMIT=128M TIMEZONE=UTC

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

RUN apk upgrade --no-cache \
 && apk add --no-cache \
    logrotate \
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
    php82-pecl-imagick \
    php82-pdo_mysql \
    php82-pdo_pgsql \
    php82-pdo_sqlite \
 && wget -q https://github.com/fossar/selfoss/releases/download/$VERSION/selfoss-$VERSION.zip -P /tmp \
 && CHECKSUM=$(sha256sum /tmp/selfoss-$VERSION.zip | awk '{print $1}') \
 && if [ "${CHECKSUM}" != "${SHA256_HASH}" ]; then echo "Warning! Checksum does not match!" && exit 1; fi \
 && mkdir /selfoss && unzip -q /tmp/selfoss-$VERSION.zip -d / \
 && rm -rf /tmp/*

COPY rootfs /
RUN chmod +x /usr/local/bin/run.sh /services/*/run /services/.s6-svscan/*
VOLUME /selfoss/data
EXPOSE 8888
CMD ["run.sh"]
