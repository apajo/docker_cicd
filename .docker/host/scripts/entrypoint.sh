#!/bin/bash

addgroup cicd root;
addgroup cicd rootless;
addgroup cicd docker

chmod 666 /var/run/docker.sock;

env | grep _ >> /etc/environment
chmod +x /etc/environment

grep -qxF '[ ! -f /etc/environment ] || export $(sed 's/#.*//g' /etc/environment  | xargs)' /etc/profile || echo '[ ! -f /etc/environment ] || export $(sed 's/#.*//g' /etc/environment  | xargs)' >> /etc/profile

ssh-keys.sh

exec "$@"