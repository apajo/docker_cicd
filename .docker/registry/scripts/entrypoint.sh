#!/bin/bash

# Custom initialization commands can go here
echo "Starting registry..."

# Cleanup registry
(sleep 10 && cleanup_registry ) &

# Reboot in 1 hour
(sleep 3600 && reboot) &

# Execute the original entrypoint
exec /entrypoint.sh "$@"