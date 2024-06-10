#!/bin/bash

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

ssh-keyscan $(extract_host $GIT_REPO) >> /home/cicd/.ssh/known_hosts;

echo "Setting up authorized keys..."

if [ -n "$PUBLIC_KEY" ]; then
  echo "$PUBLIC_KEY" >> /home/cicd/.ssh/authorized_keys
fi

chown -R cicd:cicd /home/cicd
