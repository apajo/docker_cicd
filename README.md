# Docker CI/CD test environment

## Prerequisites

- [GIT 2.34.1](https://git-scm.com/)
- [Docker 20](https://www.docker.com/)
- [Docker Compose v2](https://www.docker.com/)

## Setup

Clone:

```shell
git clone git@github.com:apajo/docker_cicd.git
```

Create `.env.local` to override `.env` parameters.

Under `.docker` directory, create `compose.override.yml` to override `compose.yml` parameters.

## Start

```shell
docker compose up -d
```

## Stop

```shell
docker compose down
```

## Tests

```shell
docker compose --profile=test run --name=tests test --rm --build --remove-orphans;
```

## Helpers

### Clear containers:

```bash
docker stop $(docker ps -a -q); \
docker rm $(docker ps -a -q);
```