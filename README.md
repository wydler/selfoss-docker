# selfoss [![Docker Image Version (tag latest)](https://img.shields.io/docker/v/wydler/selfoss/latest)](https://hub.docker.com/r/wydler/selfoss) [![Docker Image Size (tag latest)](https://img.shields.io/docker/image-size/wydler/selfoss/latest)](https://hub.docker.com/r/wydler/selfoss) [![Docker Pulls](https://img.shields.io/docker/pulls/wydler/selfoss)](https://hub.docker.com/r/wydler/selfoss) [![Docker Stars](https://img.shields.io/docker/stars/wydler/selfoss)](https://hub.docker.com/r/wydler/selfoss)

![selfoss](selfoss-logo.png "selfoss")

## What is this ?

selfoss is a multipurpose RSS reader and feed aggregation web application. It allows you to easily follow updates from different web sites, social networks and other platforms, all in single place. It is written in PHP, allowing you to run it basically anywhere.

For more information visit the [web site](https://selfoss.aditu.de) of the project.

## Features

- Lightweight & secure image (no root process)
- Based on Alpine Linux
- Latest Selfoss version (2.19)
- MySQL/MariaDB, PostgreSQL, SQLite driver
- With Nginx and PHP 8.2

## Build-time variables

- **VERSION** = selfoss version
- **SHA256_HASH** = SHA256 hash of selfoss archive

## Ports

- 8888

## Environment variables

| Variable | Description | Type | Default value |
| -------- | ----------- | ---- | ------------- |
| **UID** | selfoss user id | *optional* | 991
| **GID** | selfoss group id | *optional* | 991
| **CRON_PERIOD** | Cronjob period for updating feeds | *optional* | 15m
| **UPLOAD_MAX_SIZE** | Attachment size limit | *optional* | 25M
| **LOG_TO_STDOUT** | Enable nginx and php error logs to stdout | *optional* | false
| **MEMORY_LIMIT** | PHP memory limit | *optional* | 128M
| **TIMEZONE** | [PHP date timezone](https://www.php.net/manual/en/timezones.php) | *optional* | UTC
| **LOGROTATE_RETENTION** | Number of log files to be retained | *optional* | 31

## Usage
The simplest way to run the container is the following command:

```bash
docker run --name selfoss --detach --publish 8888:8888 --volume /opt/containers/wydler-selfoss/data:/selfoss/data/ wydler/selfoss:latest
```

Or using `docker-compose.yml`:


```yml
---
services:
  selfoss:
    image: "wydler/selfoss:latest"
    container_name: "selfoss"
    restart: "unless-stopped"
    ports:
      - "8888:8888"
    volumes:
      - "/etc/localtime:/etc/localtime:ro"
      - "/var/run/docker.sock:/var/run/docker.sock:ro"

      - "/volume1/docker/wydler-selfoss/data:/selfoss/data"
    environment:
      UID: "1048"
      GID: "65550"
      TIMEZONE: "Europe/Berlin"
```

## Credits

The image is forked from [hardware/selfoss](https://github.com/hardware/selfoss).