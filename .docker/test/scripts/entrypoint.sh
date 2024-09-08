#!/bin/bash

STAGING_HOST=$(echo $STAGING_SSH_DSN | cut -d'@' -f2 | cut -d':' -f1)
STAGING_PORT=$(echo $STAGING_SSH_DSN | cut -d':' -f2)
PRODUCTION_HOST=$(echo $PRODUCTION_SSH_DSN | cut -d'@' -f2 | cut -d':' -f1)
PRODUCTION_PORT=$(echo $STAGING_SSH_DSN | cut -d':' -f2)

wait-for-it.sh ${PRODUCTION_HOST}:${PRODUCTION_PORT} -t 60;
wait-for-it.sh ${STAGING_HOST}:${STAGING_PORT} -t 60;

source ssh-keys.sh

echo "Wait for dockerd/containerd to start..."
sleep 5;

exec "$@"