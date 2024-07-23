# 🐳 Docker CI/CD

This package provides a simple CI/CD pipeline for deploying applications using Docker.
It tests/builds your project and stores the docker images in a staging server.
After that, from a host environment you can run the images.

The package requires a single `Makefile.cicd` file in the root of your project to do it's job.

## Prerequisites

- [Linux Kernel 5.1](https://kernel.org/)
- [Runc 1.1.12](https://github.com/opencontainers/runc)
- [GIT 2.34.1](https://git-scm.com/)
- [Docker 20](https://www.docker.com/)
- [Docker Compose v2](https://www.docker.com/)

## Overview

This package consists of 3 different docker profiles/environments:
* `staging` - for testing, building and storage of your project
* `test` - for testing this package

### Flow diagram / components

![Project Logo](./docs/pipeline.png)

Components:

* Pushing - Configure your repo to run a pipeline/runners
* Git repository - Your source code repository
* Staging server - This is where your application will be tested and built (and docker images stored)
* Host server - This is where your application will be running (and updated)

## Getting started

### Clone the repository

```shell
git clone https://github.com/apajo/docker_cicd.git
```

### Setup

#### .env.local

Create `.env.local` to override `.env` parameters.


| Variable           | Description                                   | Default value                              |
|--------------------|-----------------------------------------------|--------------------------------------------|
| `GIT_REPO`         | URL of you Git repository                     | `https://github.com/apajo/docker_cicd.git` |
| `PUBLIC_KEY`       | Authorized key for staging/host servers |                                            |
| `MAKE_FILE`        | Path/name of your CI/CD make file             | `Makefile.cicd`                            |
| `STAGING_HOST`     | Host for the staging environment              | `staging`                                  |
| `STAGING_PORT`     | Port for the staging environment              | `22`                                       |
| `STAGING_USER`     | User for the staging environment              | `cicd`                                     |



#### compose.override.yml

_Additionally, you can create `compose.override.yml` to override Docker compose parameters.
For more info that, checkout [here](https://docs.docker.com/compose/)_

```yml
services:
  staging:
    ports: !override
      - "1252:22"
      - "8080:80"
    dns:
      - 8.8.8.8
      - 8.8.4.4
```

This example will override the default port for the staging server.
Add here your custom ports, volumes, etc.

### Run the servers

```shell
docker compose up -d
```

#### Run only staging server

```shell
docker compose --profile=staging up -d
```

#### Run only host server

```shell
docker compose --profile=host up -d
```

__Note!__ You can setup ad many hosts as needed (test, prelive, production, etc.) 

### Requirements for your project

> __NB!__ Make sure tou have set up your __Makefile.cicd__ file in your git repository.

__NB!__ Your git repository root directory has to have a
__Makefile.cicd__ file with the following targets:
* install
* build
* test
* push
* deploy

Example __Makefile.cicd__:

```shell
.PHONY: install build test push deploy help
.DEFAULT_GOAL := install
SHELL := /bin/bash

# Default targets
all: install build

# Require VERSION veriable
ifeq ($(filter help,$(MAKECMDGOALS)),)
    ifndef VERSION
        $(error VERSION is not set. Please set it by using VERSION=x.y.z);
    endif
endif

help:               ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install:            ## Install script
	docker compose --profile=build build --no-cache --with-dependencies

build:              ## Build script
	docker compose build --no-cache --with-dependencies

test:               ## Test script
	docker compose --profile=test run --build --remove-orphans --rm test

push:               ## Push script
	docker compose push

deploy:             ## Pull/run script
	docker compose pull
	docker compose up

```

__VERSION__ variable is defined for the deployment process.


### Run in pipeline

If environments are setup you can run the following commands to deploy the application
(for example in CI/CD pipeline):

```shell
ssh cicd@staging bash -c "stage master 12345"
ssh cicd@production bash -c "deploy master 12345"
```

## Run tests

```shell
docker compose -f .docker/compose.yml -f .docker/compose.test.yml run --rm --remove-orphans test;
docker compose -f .docker/compose.yml -f .docker/compose.test.yml down
```

Force re-build:

```shell
docker compose -f .docker/compose.yml -f .docker/compose.test.yml  down --volumes; \
docker compose -f .docker/compose.yml -f .docker/compose.test.yml run  --rm --build --remove-orphans test; \
docker compose -f .docker/compose.yml -f .docker/compose.test.yml  down;
```

## Configure host

### Systemd

1) open: sudo nano `/etc/default/grub`
2) edit: GRUB_CMDLINE_LINUX_DEFAULT="quiet splash systemd.unified_cgroup_hierarchy=1"
3) run: `sudo update-grub`
4) reboot

Script:
```shell
sudo cp /etc/default/grub /etc/default/grub.bak; \
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& systemd.unified_cgroup_hierarchy=1/' /etc/default/grub; \
sudo update-grub; \
echo "The system will reboot in 10 seconds to apply the changes. Press Ctrl+C to cancel."; \
sleep 10; \
sudo reboot;
```

## Detailed instructions

For more read [this](./.docker/README.md)

