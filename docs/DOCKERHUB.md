<p align="center">
  <img src="https://raw.githubusercontent.com/wydler/selfoss-docker/refs/heads/master/selfoss-logo.png" alt="Docker selfoss Logo" width="200" height="200">
</p>

# Docker selfoss

A lightweight Docker image for selfoss, a multipurpose RSS reader and feed aggregation web application.

[![Build and Publish Docker Image](https://github.com/wydler/selfoss-docker/actions/workflows/build.docker.images.yml/badge.svg)](https://github.com/wydler/selfoss-docker/blob/master/.github/workflows/build.docker.images.yml)

## 📦 Overview

This image runs selfoss with:

- Alpine Linux
- Nginx
- PHP 8.2
- S6 service supervision
- persistent data storage at `/selfoss/data`

The project keeps the embedded selfoss version in sync via the repository snapshot file.

## ✨ Features

- Lightweight and secure image with no root process
- Based on Alpine Linux
- Updated selfoss runtime via the snapshot configuration
- MySQL/MariaDB, PostgreSQL and SQLite support
- Nginx and PHP 8.2 runtime stack

## 🧩 Tracked selfoss versions

This repository tracks both the stable release and the current test version:

- **Stable release:** `2.19`, defined in [`selfoss.release`](https://github.com/wydler/selfoss-docker/blob/master/selfoss.release)
- **Test version (snapshot):** `2.20-3f56000`, defined in [`selfoss.snapshot`](https://github.com/wydler/selfoss-docker/blob/master/selfoss.snapshot)

Release builds use the stable version. Snapshot builds use the test version and its SHA256 checksum.

## 🏷️ Available image tags

Images are published to [`wydler/selfoss`](https://hub.docker.com/r/wydler/selfoss). The main tags are:

- **`latest`**: The most recently published stable release
- **GitHub release tag**: Pins the image to that specific release

Prereleases use their GitHub release tag and do not update `latest`. Automated snapshot builds use the test version from `selfoss.snapshot` as their tag (currently `2.20-3f56000`). The `master-compose` tag is reserved for the separate compose build.

Check the [Docker Hub tags](https://hub.docker.com/r/wydler/selfoss/tags) page for currently available tags. For reproducible deployments, pin an image digest rather than relying on a mutable tag.

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
      - "/opt/containers/wydler-selfoss/data:/selfoss/data"
    environment:
      UID: "1048"
      GID: "65550"
      TIMEZONE: "Europe/Berlin"
```

```bash
docker run --name selfoss --detach --publish 8888:8888 --volume /opt/containers/wydler-selfoss/data:/selfoss/data wydler/selfoss:latest
```

## ✅ Image verification

The published Docker image is signed with Cosign and can be verified with the repository public key:

```bash
cosign verify --key https://raw.githubusercontent.com/wydler/selfoss-docker/refs/heads/master/cosign.pub wydler/selfoss:latest
```

For a specific image digest:

```bash
cosign verify --key https://raw.githubusercontent.com/wydler/selfoss-docker/refs/heads/master/cosign.pub docker.io/wydler/selfoss:latest@sha256:<digest>
```

This confirms that the image matches the signed artifact built by the project workflow.

## 🔐 Why Cosign verification matters

The project signs the Docker image in the GitHub Actions workflow and publishes the matching public key in this repository. Verifying the image before deployment helps confirm that it is the exact artifact produced by the project workflow and has not been modified or replaced.

For production deployments, it is recommended to verify the image digest before starting the container.

The public verification key is stored in the repository as [cosign.pub](https://github.com/wydler/selfoss-docker/blob/master/cosign.pub) and is the matching key used in the GitHub Actions workflow to verify the signed image.

## ⚙️ Environment Variables

| Variable | Description | Type | Default value |
| -------- | ----------- | ---- | ------------- |
| **UID** | selfoss user id | optional | `991` |
| **GID** | selfoss group id | optional | `991` |
| **CRON_PERIOD** | Cron job period for updating feeds | optional | `15m` |
| **UPLOAD_MAX_SIZE** | Attachment size limit | optional | `25M` |
| **LOG_TO_STDOUT** | Enable nginx and PHP error logging to stdout | optional | `false` |
| **MEMORY_LIMIT** | PHP memory limit | optional | `128M` |
| **TIMEZONE** | [PHP timezone](https://www.php.net/manual/en/timezones.php) | optional | `UTC` |
| **LOGROTATE_RETENTION** | Number of log files to keep | optional | `31` |

## 🔒 Security recommendations

- Keep the default non-root service identity (`UID=991`, `GID=991`) or set `UID` and `GID` to an unprivileged account appropriate for your host. Ensure the `/selfoss/data` bind mount is writable by that account.
- Do not run the container with `--privileged` or add capabilities unless you have a specific, reviewed need.
- Expose port `8888` only to networks that should access selfoss. If a reverse proxy runs on the Docker host, bind the port to localhost (for example, `127.0.0.1:8888:8888`) and terminate HTTPS at the proxy.
- Keep the image up to date. For production, use a specific release tag or digest and verify its signature with Cosign before deployment.

## 🛠️ Troubleshooting

- **Data directory permission errors:** Ensure the host directory mounted at `/selfoss/data` is writable by the configured `UID` and `GID`.
- **Need more details in container logs:** Run `docker logs -f selfoss`. Set `LOG_TO_STDOUT=true` to send Nginx and PHP error logs to stdout. Selfoss application logs are stored in `/selfoss/data/logs`.
- **Feeds are not updating as often as expected:** Check `CRON_PERIOD`; its default is `15m`.
- **Uploads are rejected due to size:** Increase `UPLOAD_MAX_SIZE`, which configures the upload limit for both Nginx and PHP.
- **PHP reports memory exhaustion:** Increase `MEMORY_LIMIT` to give PHP more memory.
- **PHP timestamps use the wrong timezone:** Set `TIMEZONE` to a valid [PHP timezone](https://www.php.net/manual/en/timezones.php), such as `Europe/Berlin`.

## 🔗 Links

- [GitHub Repository](https://github.com/wydler/selfoss-docker)
- [Full Documentation](https://github.com/wydler/selfoss-docker/blob/master/README.md)
- [selfoss Project](https://selfoss.aditu.de)

## 📄 License

This project is licensed under the GNU GENERAL PUBLIC LICENSE.