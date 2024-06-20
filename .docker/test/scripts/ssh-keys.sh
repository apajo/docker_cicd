#!/bin/bash

STAGING_HOST=$(echo $STAGING_SSH_DSN | cut -d'@' -f2 | cut -d':' -f1)
STAGING_PORT=$(echo $STAGING_SSH_DSN | cut -d':' -f2)
PRODUCTION_HOST=$(echo $PRODUCTION_SSH_DSN | cut -d'@' -f2 | cut -d':' -f1)
PRODUCTION_PORT=$(echo $STAGING_SSH_DSN | cut -d':' -f2)

extract_host() {
    local url=$1
    if [[ $url =~ ^git@ ]]; then
        echo "${url#*@}" | sed 's/:.*//'
    else
        echo "${url#*://}" | sed 's:/.*::'
    fi
}

if [ ! -f /home/cicd/.ssh/id_rsa ]; then
  echo "Generating public key..."

  ssh-keygen -t rsa -b 4096 -f /home/cicd/.ssh/id_rsa -N ""

  cat /home/cicd/.ssh/id_rsa.pub >> /home/cicd/.ssh/authorized_keys
fi

echo "Setting up known hosts..."

ssh-keyscan -p ${STAGING_PORT} ${STAGING_HOST} >> /home/cicd/.ssh/known_hosts
ssh-keyscan -p ${PRODUCTION_PORT} ${PRODUCTION_HOST} >> /home/cicd/.ssh/known_hosts

ssh-keyscan $(extract_host $GIT_REPO) >> /home/cicd/.ssh/known_hosts;

echo "Setting up authorized keys..."

sshpass -p 'KollaneHobune' ssh-copy-id -p ${STAGING_PORT} ${STAGING_HOST}
sshpass -p 'KollaneHobune' ssh-copy-id -p ${PRODUCTION_PORT} ${PRODUCTION_HOST}

if [ -n "$PUBLIC_KEY" ]; then
  echo "$PUBLIC_KEY" >> /home/cicd/.ssh/authorized_keys
fi

chown -R cicd:cicd /home/cicd
