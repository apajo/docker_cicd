#!/bin/bash

echo -e "\nReady to run the tests ... \n"

# Generate a random number for the version variable
version=$RANDOM

echo "Testing / building ..."

bin/ssh/staging stage test_repo $version;

echo "Setting up built image ..."

bin/ssh/prod deploy test_repo $version;