############################
# Stage 1: Builder
############################
FROM alpine:3.22.4@sha256:310c62b5e7ca5b08167e4384c68db0fd2905dd9c7493756d356e893909057601 AS builder

ARG APP_FILE_HASH
ARG APP_DL_PATH

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

# Build dependencies (nur temporär)
RUN apk add --no-cache wget unzip ca-certificates

WORKDIR /tmp/selfoss

# Selfoss herunterladen + checksum prüfen
RUN wget -q ${APP_DL_PATH} -O selfoss.zip \
    && echo "${APP_FILE_HASH}  selfoss.zip" | sha256sum -c - \
    && unzip -q selfoss.zip -d . \
    && mv selfoss /selfoss \
    && rm -rf ./*

############################
# Stage 2: Runtime
############################
FROM alpine:3.22.4@sha256:310c62b5e7ca5b08167e4384c68db0fd2905dd9c7493756d356e893909057601

############################
# Metadata
############################
LABEL maintainer="Daniel Wydler" \
      org.opencontainers.image.authors="Daniel Wydler" \
      org.opencontainers.image.description="Up-to-date Selfoss, a multipurpose RSS reader, live stream, mashup, aggregation web application." \
      org.opencontainers.image.documentation="https://github.com/wydler/selfoss-docker/blob/master/README.md" \
      org.opencontainers.image.source="https://github.com/wydler/selfoss-docker" \
      org.opencontainers.image.title="wydler/selfoss" \
      org.opencontainers.image.url="https://github.com/wydler/selfoss-docker"

############################
# Arguments & Environment
############################
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
# Runtime dependencies
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
# Selfoss kopieren
############################
COPY --from=builder /selfoss /selfoss
RUN mkdir -p /selfoss/data

############################
# Security adjustments
############################
RUN setcap cap_setgid=ep /bin/busybox \
    && rm -rf /etc/logrotate.d/* \
    && rm -f /etc/crontabs/root

############################
# RootFS & Permissions
############################
COPY rootfs /
RUN chmod +x /usr/local/bin/run.sh /services/*/run /services/.s6-svscan/*

############################
# Runtime
############################
VOLUME /selfoss/data
EXPOSE 8888

############################
# Entrypoint
############################
ENTRYPOINT ["/usr/local/bin/run.sh"]