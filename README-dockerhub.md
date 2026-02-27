<p align="center">
  <img src="https://raw.githubusercontent.com/dwydler/selfoss-docker/refs/heads/master/selfoss-logo.png" alt="Docker selfoss Logo" width="200" height="200">
</p>

# Docker Selfoss

A lightweight Docker image for the ultimate multi-purpose RSS reader, data stream, mash-up, aggregation web application

[![Build and Publish Docker Image](https://github.com/dwydler/selfoss-docker/actions/workflows/build.docker.images.yml/badge.svg)](https://github.com/dwydler/selfoss-docker/blob/master/.github/workflows/build.docker.images.yml)

## 📦 Available Tags

**Choose the right version for your environment:**

- **`latest`**: Latest stable build - recommended for testing
- **`2.19.0`**: Specific version - recommended for production

Example: `wydler/logrotate:2.19.0`

## 🔄 Overview

This container runs logrotate to manage log files from other containers in your Docker environment. It helps prevent log files from growing too large and consuming all available disk space.

## ✨ Features

- Lightweight & secure image (no root process)
- Based on Alpine Linux
- Latest Selfoss version (2.19)
- MySQL/MariaDB, PostgreSQL, SQLite driver
- With Nginx and PHP 8.2

## 🚀 Quick Start

```yaml
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

## ⚙️ Environment Variables

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

## 🔗 Links

- [GitHub Repository](https://github.com/dwydler/selfoss-docker)
- [Full Documentation](https://github.com/dwydler/selfoss-docker/blob/master/README.md)

## 📄 License

This project is licensed under the GNU GENERAL PUBLIC LICENSE.