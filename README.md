# selfoss [![Docker Image Version (tag latest)](https://img.shields.io/docker/v/wydler/selfoss/latest)](https://hub.docker.com/r/wydler/selfoss) [![Docker Image Size (tag latest)](https://img.shields.io/docker/image-size/wydler/selfoss/latest)](https://hub.docker.com/r/wydler/selfoss) [![Docker Pulls](https://img.shields.io/docker/pulls/wydler/selfoss)](https://hub.docker.com/r/wydler/selfoss) [![Docker Stars](https://img.shields.io/docker/stars/wydler/selfoss)](https://hub.docker.com/r/wydler/selfoss)

![selfoss](selfoss-logo.png "selfoss")

## What is this?

selfoss is a multipurpose RSS reader and feed aggregation web application. It lets you follow updates from websites, social networks, and other sources in one place. The application is written in PHP and can run in many environments.

For more information, visit the [selfoss project website](https://selfoss.aditu.de).

## Features

- Lightweight and secure image with no root process
- Based on Alpine Linux
- Selfoss runtime kept up to date via the repository snapshot file
- MySQL/MariaDB, PostgreSQL and SQLite support
- Nginx and PHP 8.2 runtime stack
- Built with S6 for service supervision

## Tracked selfoss versions

This repository tracks two upstream versions:

- Stable release: `2.19`, defined in [selfoss.release](selfoss.release)
- Test version (snapshot): `2.20-3f56000`, defined in [selfoss.snapshot](selfoss.snapshot)

The stable release is used for release builds. Snapshot builds use the test version and its SHA256 checksum.

## Image tags

The image is published as [`wydler/selfoss`](https://hub.docker.com/r/wydler/selfoss). The main tags are:

- `latest` — the most recently published stable release
- A version tag matching the corresponding GitHub release tag — use this to pin a specific release

Prereleases use their GitHub release tag and do not update `latest`. Automated snapshot builds use the test version from `selfoss.snapshot` as their tag (currently `2.20-3f56000`). The `master-compose` tag is reserved for the separate compose build.

See the [Docker Hub tags](https://hub.docker.com/r/wydler/selfoss/tags) page for tags currently available. For reproducible deployments, pin an image digest rather than relying on a mutable tag.

## Build-time variables

- **VERSION** = selfoss version
- **SHA256_HASH** = SHA256 hash of the downloaded archive
- **URL** = download URL for the selfoss archive

## Ports

- `8888`

## Environment variables

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

## Usage

The simplest way to run the container is:

```bash
docker run --name selfoss --detach --publish 8888:8888 --volume /opt/containers/wydler-selfoss/data:/selfoss/data wydler/selfoss:latest
```

Using `docker-compose.yml`:

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
      - "/opt/containers/wydler-selfoss/data:/selfoss/data"
    environment:
      UID: "1048"
      GID: "65550"
      TIMEZONE: "Europe/Berlin"
```

## Image verification with Cosign

The Docker image is signed during the build pipeline and can be verified locally with the public key in this repository:

```bash
cosign verify --key ./cosign.pub wydler/selfoss:latest
```

If you want to verify a specific digest instead of the tag:

```bash
cosign verify --key ./cosign.pub docker.io/wydler/selfoss:latest@sha256:<digest>
```

This helps confirm that the image you pulled matches the signed artifact from the project workflow.

## Why Cosign verification matters

The project signs the image with a private key during the GitHub Actions build and publishes the matching public key in this repository. Verifying the image before deployment gives you a simple way to confirm that the container you pulled is the exact artifact produced by the workflow and not a modified or tampered image.

For production use, prefer validating the digest of the image you plan to run and compare it against the signed reference in your registry.

The public key is stored in [cosign.pub](cosign.pub) in the repository root. It is the matching verification key used by the GitHub Actions workflow when the image is signed and later checked.

## Security recommendations

- Keep the default non-root service identity (`UID=991`, `GID=991`) or set `UID` and `GID` to an unprivileged account appropriate for your host. Make sure the `/selfoss/data` bind mount is writable by that account.
- Do not run the container with `--privileged` or add capabilities unless you have a specific, reviewed need.
- Expose port `8888` only to networks that should access selfoss. For a reverse proxy running on the Docker host, you can bind it to localhost, for example `--publish 127.0.0.1:8888:8888`, and terminate HTTPS at the proxy.
- Keep the image up to date. For production, use a specific release tag or digest and verify its signature with Cosign before deployment.

## Troubleshooting

- **Data directory permission errors:** Ensure the host directory mounted at `/selfoss/data` is writable by the configured `UID` and `GID`.
- **Need more details in container logs:** Run `docker logs -f selfoss`. Set `LOG_TO_STDOUT=true` to send Nginx and PHP error logs to stdout. Selfoss application logs are stored in `/selfoss/data/logs`.
- **Feeds are not updating as often as expected:** Check `CRON_PERIOD`; its default is `15m`.
- **Uploads are rejected due to size:** Increase `UPLOAD_MAX_SIZE`, which configures the upload limit for both Nginx and PHP.
- **PHP reports memory exhaustion:** Increase `MEMORY_LIMIT` to give PHP more memory.
- **PHP timestamps use the wrong timezone:** Set `TIMEZONE` to a valid [PHP timezone](https://www.php.net/manual/en/timezones.php), such as `Europe/Berlin`.

## Notes

- The container exposes the web interface on port `8888`.
- Data is persisted in `/selfoss/data`.
- The default cron interval is `15m`, but it can be configured with `CRON_PERIOD`.

## Credits

This image is based on the project at [hardware/selfoss](https://github.com/hardware/selfoss).