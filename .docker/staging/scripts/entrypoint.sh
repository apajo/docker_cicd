#!/bin/bash

set -x

addgroup cicd root;
addgroup cicd docker

env | grep _ | sed 's/^\([^=]*\)=\(.*\)$/\1="\2"/' >> /etc/environment
chmod +x /etc/environment

# Update /etc/profile to export environment variables except PUBLIC_KEY
grep -qxF '[ ! -f /etc/environment ] || export $(sed 's/#.*//g' /etc/environment | grep -v PUBLIC_KEY | xargs)' /etc/profile || echo '[ ! -f /etc/environment ] || export $(sed 's/#.*//g' /etc/environment | grep -v PUBLIC_KEY | xargs)' >> /etc/profile

ssh-keys.sh

# /usr/bin/enable_cgroup_nesting.sh

# Update /etc/docker/daemon.json with DNS_SERVERS
if [ ! -z "$DNS_SERVERS" ]; then
  # Convert DNS_SERVERS to a quoted comma-separated JSON-like array
  DNS_ARRAY=$(echo $DNS_SERVERS | sed 's/[^,]*/"&"/g')
  export DNS_SERVERS=$DNS_ARRAY
else
  export DNS_SERVERS=""
fi
envsubst < /etc/docker/daemon.json.template > /etc/docker/daemon.json

# Start Docker daemon in the background
#dockerd --tls=false &
# dockerd-entrypoint.sh &

dockerd-entrypoint.sh &

# Wait for Docker to start
# until docker info >/dev/null 2>&1; do
#   sleep 1
# done

# Start SSHD in the foreground
exec /usr/sbin/sshd -D -e

# exec  "$@"