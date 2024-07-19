#!/bin/bash
set -e

# Define color variables
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "\nReady to run the tests ... \n"

# For testing purposes, we will keep the container running
# tail -f /dev/null

check_command() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: $1 failed!${NC}"
        exit 1
    fi
}

# Loop that iterates 10 times
for ((i=1; i<=1; i++))
do
  echo -e "\nRunning iteration $i/10 ... \n"

  # Generate a random number for the version variable
  version=$RANDOM

  echo "Testing / building ($version) ..."

  bin/ssh/staging stage test_repo $version;
  check_command "Staging"

  echo "Setting up built image ($version) ..."

  bin/ssh/prod deploy test_repo $version;
  check_command "Deploying"

done
