# Docker CI/CD


## Prerequisites

- [GIT 2.34.1](https://git-scm.com/)
- [Docker 20](https://www.docker.com/)
- [Docker Compose v2](https://www.docker.com/)

## Overview

This package consists of 3 different docker profiles/environments:
* `staging` - for testing, building and image storage
* `production` - for production application container
* `test` - for testing

### Flow diagram / components

![Project Logo](./docs/pipeline.png)

Components:

* Pushing - pushing code to the repository
* Git repository - any source code repository (with pipelines)
* Staging server - server for testing and image storage
* Production server - server for production application


## Getting started

### Clone the repository

```shell
git clone --recurse-submodules https://github.com/apajo/docker_cicd.git
```

### Setup

#### .env

Create `.env.local` to override `.env` parameters.


| Variable           | Description                                   | Default value                              |
|--------------------|-----------------------------------------------|--------------------------------------------|
| `GIT_REPO`         | URL of you Git repository                     | `https://github.com/apajo/docker_cicd.git` |
| `PUBLIC_KEY`       | Authorized key for staging/production servers |                                            |
| `MAKE_FILE`        | Path/name of your CI/CD make file             | `Makefile.cicd`                            |
| `STAGING_HOST`     | Host for the staging environment              | `staging`                                  |
| `STAGING_PORT`     | Port for the staging environment              | `22`                                       |
| `STAGING_USER`     | User for the staging environment              | `cicd`                                     |
| `PRODUCTION_HOST`  | Host for the production environment           | `production`                               |
| `PRODUCTION_PORT`  | Port for the production environment           | `22`                                       |
| `PRODUCTION_USER`  | User for the production environment           | `cicd`                                     |


_Additionally, you can create `compose.override.yml` to override `compose.yml` parameters. For more info taht, checkout [here](https://docs.docker.com/compose/)_

### Start

__Profile__ can be one of: __staging / prod / test__

```shell
docker compose --profile=[profile] up -d
```

### Stop

```shell
docker compose --profile=[profile] down
```

### Run tests

```shell
docker compose --profile=test run --name=tests --rm --build --remove-orphans test;
```
## Detailed setup

You need to setup 2 environents: `staging` and `production`.

### Staging

1. Clone this repo (https://github.com/apajo/docker_cicd)
2. Edit environment variables by creating `.env.local` file
2. Run `docker compose --profile=staging up -d`

### Production

1. Clone this repo (https://github.com/apajo/docker_cicd)
2. Edit environment variables by creating `.env.local` file
2. Run `docker compose --profile=prod up -d`

### Common

To publish public keys to and from the staging and production servers, run:

```shell
bin/publish-keys
```

__NB!__ This script needs your PUBLIC_KEY to be correctly set in the `.env.local` file.

This will copy the public keys from the staging server to the production server and vice versa.

And you will be printed the public keys to be set in your GIT repository's access keys.

### Finished

## Helpers (for containers)

### Enter interactive shell

```shell
docker exec -it --user cicd staging bash
```

### Get public key from the container

```shell
docker exec -it --user cicd staging bash -c "cat ~/.ssh/id_rsa.pub"
```

### Add your/host public key to authorized keys in the container

```shell
PUBLIC_KEY=$(cat $HOME/.ssh/id_rsa.pub); \
docker exec -it --user cicd production bash -c "echo $PUBLIC_KEY >> ~/.ssh/authorized_keys"
```

### Add a domain to known hosts

```shell
read -p "Enter the domain: " DOMAIN; \
docker exec -it --user cicd staging bash -c "ssh-keyscan $DOMAIN >> ~/.ssh/known_hosts"
```

### Clear containers:

```bash
docker stop $(docker ps -a -q); \
docker rm $(docker ps -a -q);
```

### Setup Docker registry

```bash
docker run -d -p 5000:5000 --name local-registry registry:2
```
