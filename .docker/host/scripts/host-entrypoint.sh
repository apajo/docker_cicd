#!/bin/bash

echo "Host entrypoint..."

addgroup cicd root;
addgroup cicd rootless;
addgroup cicd docker

chmod 666 /var/run/docker.sock;

env | grep _ | sed 's/^\([^=]*\)=\(.*\)$/\1="\2"/' >> /etc/environment
chmod +x /etc/environment

# Update /etc/profile to export environment variables except PUBLIC_KEY
grep -qxF '[ ! -f /etc/environment ] || export $(sed 's/#.*//g' /etc/environment | grep -v PUBLIC_KEY | xargs)' /etc/profile || echo '[ ! -f /etc/environment ] || export $(sed 's/#.*//g' /etc/environment | grep -v PUBLIC_KEY | xargs)' >> /etc/profile

wait-for-it.sh ${STAGING_HOST}:${STAGING_PORT} -t 60;

ssh-keyscan ${STAGING_HOST} >> /home/cicd/.ssh/known_hosts;

echo -e "\Host is ready ... \n"

exec "$@"