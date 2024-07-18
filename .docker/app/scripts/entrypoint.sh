#!/bin/sh

echo -e "\nApp is running ... \n"

sleep 1

echo -e "\nList files in volume volume /app/volume ... \n"
ls -la /app/volume

sleep 1

echo -e "\nTest TCP server/socket ... \n"

PORT=8765
exec 3<>/dev/tcp/localhost/$PORT
# Check if the socket creation was successful
if [ $? -ne 0 ]; then
  echo "Failed to create TCP socket at port $PORT"
  exit 1
else
  echo "Successfully created TCP socket at port $PORT"
  exec 3>&-
  exec 3<&-
fi

echo -e "\nEnvironment variable VERSION: ${VERSION} \n"
echo -e "\nEnvironment variable SOME_ENV_VALUE: ${SOME_ENV_VALUE} \n"

sleep 1

echo -e "\nChecking DNS lookup ... \n"

nslookup github.com

if [ $? -ne 0 ]; then
  echo -e "GitHub DNS lookup failed!"
  exit 1
fi

nslookup google.com

if [ $? -ne 0 ]; then
  echo -e "Google DNS lookup failed!"
  exit 1
fi


echo -e "\nApp is exiting ... \n"

#exit 0;