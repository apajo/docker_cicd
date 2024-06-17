#!/bin/bash

echo -e "\nReady to run the tests ... \n"

wait-for-it.sh ${STAGING_HOST}:${STAGING_PORT} -t 10;

echo "Testing / building ..."

bin/ssh/staging stage test_repo 12345;

wait-for-it.sh ${PRODUCTION_HOST}:${PRODUCTION_PORT} -t 10;

echo "Setting up built image ..."

bin/ssh/prod deploy test_repo 12345;