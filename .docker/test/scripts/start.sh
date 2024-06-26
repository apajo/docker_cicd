#!/bin/bash

echo -e "\nReady to run the tests ... \n"

# For testing purposes, we will keep the container running
# tail -f /dev/null


# Loop that iterates 10 times
for ((i=1; i<=1; i++))
do
  echo -e "\nRunning iteration $i/10 ... \n"

  # Generate a random number for the version variable
  version=$RANDOM

  echo "Testing / building ($version) ..."

  bin/ssh/staging stage test_repo $version;

  echo "Setting up built image ($version) ..."

  bin/ssh/prod deploy test_repo $version;
done
