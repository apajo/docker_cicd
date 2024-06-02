#!/bin/bash

echo "Production entrypoint..."

chmod 666 /var/run/docker.sock;

/usr/bin/entrypoint.sh

wait-for-it.sh ${STAGING_HOST}:${STAGING_PORT} -t 60;

ssh-keyscan ${STAGING_HOST} >> /home/cicd/.ssh/known_hosts;

echo -e "\nProduction is ready ... \n"

exec "$@"