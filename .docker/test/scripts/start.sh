#!/bin/bash
set -e

NC='\033[0m'     # No color (resets text formatting)

# Regular Colors
BLACK='\033[0;30m'   # Black
RED='\033[0;31m'     # Red
GREEN='\033[0;32m'   # Green
YELLOW='\033[0;33m'  # Yellow
BLUE='\033[0;34m'    # Blue
PURPLE='\033[0;35m'  # Purple
CYAN='\033[0;36m'    # Cyan
WHITE='\033[0;37m'   # White

# Bold
BOLD_BLACK='\033[1;30m'  # Black
BOLD_RED='\033[1;31m'    # Red
BOLD_GREEN='\033[1;32m'  # Green
BOLD_YELLOW='\033[1;33m' # Yellow
BOLD_BLUE='\033[1;34m'   # Blue
BOLD_PURPLE='\033[1;35m' # Purple
BOLD_CYAN='\033[1;36m'   # Cyan
BOLD_WHITE='\033[1;37m'  # White

PRODUCTION_USER=$(echo $PRODUCTION_SSH_DSN | cut -d'@' -f1)
PRODUCTION_HOST=$(echo $PRODUCTION_SSH_DSN | cut -d'@' -f2 | cut -d':' -f1)
PRODUCTION_PORT=$(echo $STAGING_SSH_DSN | cut -d':' -f2)
STAGING_USER=$(echo $STAGING_SSH_DSN | cut -d'@' -f1)
STAGING_HOST=$(echo $STAGING_SSH_DSN | cut -d'@' -f2 | cut -d':' -f1)
STAGING_PORT=$(echo $STAGING_SSH_DSN | cut -d':' -f2)

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

  SSH_URL="${STAGING_USER}@${STAGING_HOST} -p ${STAGING_PORT}"
  ssh ${SSH_URL} -C "stage-full test_repo $version";
  check_command "Staging"

  echo "Setting up built image ($version) ..."

  SSH_URL="${PRODUCTION_USER}@${PRODUCTION_HOST} -p ${PRODUCTION_PORT}"
  ssh ${SSH_URL} -C "deploy test_repo $version";
  check_command "Deploying"

done
