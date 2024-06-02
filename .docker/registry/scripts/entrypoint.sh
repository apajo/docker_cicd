#!/bin/bash

# Custom initialization commands can go here
echo "Starting registry..."

# registry.py -l user:pass -r http://localhost:5000 --delete

# Delete images (except last n) in 10 seconds
(sleep 10 && (echo "Deleting images (except 10 last ones)..." && registry.py -r http://localhost:5000 --delete -n 10)) &

# Reboot in 10 hours
(sleep 36000 && reboot) &

# Execute the original entrypoint
exec /entrypoint.sh "$@"