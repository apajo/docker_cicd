#!/bin/bash

addgroup cicd root;
addgroup cicd rootless;
addgroup cicd docker

env | grep _ | sed 's/^\([^=]*\)=\(.*\)$/\1="\2"/' >> /etc/environment
chmod +x /etc/environment

# Update /etc/profile to export environment variables except PUBLIC_KEY
grep -qxF '[ ! -f /etc/environment ] || export $(sed 's/#.*//g' /etc/environment | grep -v PUBLIC_KEY | xargs)' /etc/profile || echo '[ ! -f /etc/environment ] || export $(sed 's/#.*//g' /etc/environment | grep -v PUBLIC_KEY | xargs)' >> /etc/profile

ssh-keys.sh

# Start dockerd
dockerd --tls=false &

# Start sshd
# /usr/sbin/sshd -D -e > /dev/stdout 2>/dev/stderr &

exec "$@"