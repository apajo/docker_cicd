#!/bin/bash

echo -e "\nReady to run the tests ... \n"

wait-for-it.sh ${STAGING_HOST}:${STAGING_PORT} -t 10;

echo "Deploying ..."

bin/ssh/staging stage test_repo 12345;

wait-for-it.sh ${PRODUCTION_HOST}:${PRODUCTION_PORT} -t 10;

echo "Setting up prod env ..."

bin/ssh/prod "deploy prod_12345";