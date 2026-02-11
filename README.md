# Orchestrator

## Changing a repository in `clone.sh`

- Edit the `REPOS` array; directory name = last segment of URL before `.git`.
- In `docker-compose.yaml`: set `build.context` and all volume paths to `./<directory-name>`. Update `build.dockerfile` if needed.

## Adding a repository

1. **clone.sh** — Add URL to `REPOS`.
2. **docker-compose.yaml** — Add a service: `build.context: ./<directory-name>`, `build.dockerfile` (e.g. `../Dockerfile` or `../Dockerfile.service-name`), volumes from `./<directory-name>/...`.

## Adding a service in Docker Compose

Add a service with `build.context` (cloned dir) and `build.dockerfile` (path relative to context). Keep directory name in sync with `clone.sh`.

## Adding a new Dockerfile

- **Naming:** In the orchestrator use `Dockerfile.<service-name>` (e.g. `Dockerfile.backend`, `Dockerfile.api`).
- **Reference:** In docker-compose, `build.dockerfile` is relative to `build.context` (e.g. context `./my-app` → `../Dockerfile.my-app`).
