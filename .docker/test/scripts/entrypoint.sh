#!/bin/bash

wait-for-it.sh ${PRODUCTION_HOST}:${PRODUCTION_PORT} -t 60;
wait-for-it.sh ${STAGING_HOST}:${STAGING_PORT} -t 60;

source ssh-keys.sh

echo -e "\nReady to run the tests ... \n"

exec "$@"