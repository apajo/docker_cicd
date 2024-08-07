# 🐳 Docker CI/CD docs

### To customize build/staging commands

To override default `docker compose ...` commands ran while staging/deploying, you need to add __Makefile.cicd__ file in your git repository root directory.

__Makefile.cicd__ should have the following targets:
* install - Pre-build phase (build static images etc)
* build   - Main build phase
* test    - Runs your project tests
* push    - Pushes built images to the registry
* deploy  - Runs an image (pulls from registry if needed)

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
	docker compose run --build --remove-orphans --rm test
	docker compose down # Remove any tangling containers

push:               ## Push script
	docker compose push

deploy:             ## Pull/run script
	docker compose pull
	docker compose up

```

__VERSION__ variable is defined for the deployment process.