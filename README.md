# debian-slim-lftp

[![Build and push Docker image](https://github.com/jesuswasrasta/debian-slim-lftp/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/jesuswasrasta/debian-slim-lftp/actions/workflows/docker-publish.yml)
[![Docker Hub](https://img.shields.io/docker/pulls/jesuswasrasta/debian-slim-lftp)](https://hub.docker.com/r/jesuswasrasta/debian-slim-lftp)

A slim Debian-based image for deployments over FTP/SFTP, with `lftp` preinstalled.

## What's inside

Based on `debian:trixie-slim`, plus:

| Package | Purpose |
|---|---|
| `lftp` | scriptable FTP/SFTP transfers (mirror, deploy) |
| `openssh-client`, `ssh` | SSH/SFTP connectivity and key handling |
| `sshpass` | password-based SSH auth in non-interactive scripts |
| `git` | fetch sources or metadata at deploy time |

## Supported tags and platforms

- `latest` tracks the `master` branch
- `master`, `sha-<commit>` for exact builds
- `1.2.3`, `1.2`, `1` for Git tags like `v1.2.3`
- Platforms: `linux/amd64`, `linux/arm64`

## Quick start

```bash
docker pull jesuswasrasta/debian-slim-lftp:latest
docker run --rm -it jesuswasrasta/debian-slim-lftp:latest lftp --version
```

Mirror a local folder to a remote FTP host:

```bash
docker run --rm \
  -v "$PWD:/work" -w /work \
  jesuswasrasta/debian-slim-lftp:latest \
  lftp -c "open -u $FTP_USER,$FTP_PASSWORD $FTP_HOST; mirror -R --delete ./dist /public_html"
```

Same over SFTP with key auth:

```bash
docker run --rm \
  -v "$PWD:/work" -w /work \
  -v "$HOME/.ssh:/root/.ssh:ro" \
  jesuswasrasta/debian-slim-lftp:latest \
  lftp -c "open sftp://$SFTP_USER@$SFTP_HOST; mirror -R ./dist /var/www/html"
```

## Use in CI

Example GitHub Actions step to deploy via FTP:

```yaml
- name: Deploy via FTP
  uses: docker://jesuswasrasta/debian-slim-lftp:latest
  env:
    FTP_USER: ${{ secrets.FTP_USER }}
    FTP_PASSWORD: ${{ secrets.FTP_PASSWORD }}
    FTP_HOST: ${{ secrets.FTP_HOST }}
  with:
    args: lftp -c "open -u $FTP_USER,$FTP_PASSWORD $FTP_HOST; mirror -R --delete ./dist /public_html"
```

## Build locally

```bash
docker build -t debian-slim-lftp:local .
docker run --rm debian-slim-lftp:local lftp --version
```

## Automated builds

Pushes to `master` and tags `v*.*.*` trigger `.github/workflows/docker-publish.yml`, which builds for `amd64`/`arm64` and pushes to Docker Hub. Pull requests only build, without pushing. It authenticates with the `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` repository secrets (Docker Hub personal access token with Read and Write scope).

## Links

- Docker Hub: [jesuswasrasta/debian-slim-lftp](https://hub.docker.com/r/jesuswasrasta/debian-slim-lftp)
- GitHub: [jesuswasrasta/debian-slim-lftp](https://github.com/jesuswasrasta/debian-slim-lftp)
