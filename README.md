# Docker CI/CD


## Prerequisites

- [GIT 2.34.1](https://git-scm.com/)
- [Docker 20](https://www.docker.com/)
- [Docker Compose v2](https://www.docker.com/)

## Overview

This package consists of 3 different docker profiles/environments:
* `staging` - for testing, building and image storage
* `production` - for host/production environment
* `test` - for testing this package

### Flow diagram / components

![Project Logo](./docs/pipeline.png)

Components:

* Pushing - pushing code to the repository
* Git repository - any source code repository
* Staging server - server for testing, building and dockder image storage
* Production server - application host/server

## Getting started

### Clone the repository

```shell
git clone https://github.com/apajo/docker_cicd.git
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

_Additionally, you can create `compose.override.yml` to override `compose.yml` parameters. For more info taht, checkout [here](https://docs.docker.com/compose/)_

### Overview

__Profile__ can be one of: __staging / prod / test__

```shell
docker compose --profile=[profile] up -d
```

### Stop

```shell
docker compose --profile=[profile] down
```

### Run staging server

1. Clone this repo (https://github.com/apajo/docker_cicd)
2. Edit environment variables by creating `.env.local` file
3. Run:

```shell
docker compose --profile=staging up -d
```

### Run production/host server

1. Clone this repo (https://github.com/apajo/docker_cicd)
2. Edit environment variables by creating `.env.local` file
3. Setup your public keys in staging and production servers
4. Run:

```shell
docker compose --profile=prod up -d
```
### Run in pipeline

If environments are setup you can run the following commands to deploy the application
(for example in CI/CD pipeline):

```shell
ssh cicd@staging bash -c "stage master 12345"
ssh cicd@production bash -c "deploy master 12345"
```

### Run tests

```shell
docker compose --profile=test run --name=tests --rm --build --remove-orphans test;
```

## Helpers / shortcuts

#### Enter interactive shell

```shell
docker exec -it --user cicd staging bash
```

#### Get public key from the container

```shell
docker exec -it --user cicd staging bash -c "cat ~/.ssh/id_rsa.pub"
```

#### Add your/host public key to authorized keys in the container

```shell
PUBLIC_KEY=$(cat $HOME/.ssh/id_rsa.pub); \
docker exec -it --user cicd production bash -c "echo $PUBLIC_KEY >> ~/.ssh/authorized_keys"
```

#### Add a domain to known hosts

```shell
read -p "Enter the domain: " DOMAIN; \
docker exec -it --user cicd staging bash -c "ssh-keyscan $DOMAIN >> ~/.ssh/known_hosts"
```

#### Clear containers:

```bash
docker stop $(docker ps -a -q); \
docker rm $(docker ps -a -q);
```

#### Setup Docker registry

```bash
docker run -d -p 5000:5000 --name local-registry registry:2
```
