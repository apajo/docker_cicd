#!/bin/bash

echo "Deploying ..."

bin/ssh/staging /home/cicd/bin/deploy test_repo 12345;

echo "Setting up prod env ..."

bin/ssh/prod "cd /app; bin/pull prod_12345";