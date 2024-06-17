#!/bin/bash

addgroup cicd root;
addgroup cicd rootless;
addgroup cicd docker

chmod 666 /var/run/docker.sock;

env | grep _ | sed 's/^\([^=]*\)=\(.*\)$/\1="\2"/' >> /etc/environment
chmod +x /etc/environment

# Update /etc/profile to export environment variables except the excluded ones
EXCLUDED_VARS="PUBLIC_KEY,SSH_PASSWORD"
EXCLUDED_VARS_PATTERN=$(echo $EXCLUDED_VARS | sed 's/,/|/g')
grep -qxF '[ ! -f /etc/environment ] || export $(sed "s/#.*//g" /etc/environment | grep -Ev "($EXCLUDED_VARS_PATTERN)" | xargs)' /etc/profile || echo '[ ! -f /etc/environment ] || export $(sed "s/#.*//g" /etc/environment | grep -Ev "($EXCLUDED_VARS_PATTERN)" | xargs)' >> /etc/profile

ssh-keys.sh

exec "$@"