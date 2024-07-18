#!/bin/sh

echo -e "\nApp is running ... \n"

sleep 1

echo -e "\nList files in /app ... \n"

tree /app

sleep 1

# Start a simple TCP server using socat
echo -e "\nTest TCP server/socket ... \n"

PORT=8765
socat TCP-LISTEN:$PORT,fork EXEC:'/bin/cat' &
SOCAT_PID=$!

# Give socat some time to start
sleep 2

# Check if socat command is still running using pgrep
if pgrep -f "socat TCP-LISTEN:$PORT" > /dev/null; then
  echo "Successfully created TCP socket at port $PORT"
else
  echo "Failed to create TCP socket at port $PORT"
  exit 1
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