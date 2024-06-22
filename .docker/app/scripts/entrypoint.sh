#!/bin/sh

echo -e "\nApp is running ... \n"

sleep 1

echo -e "\nEnvironment variable VERSION: ${VERSION} \n"
echo -e "\nEnvironment variable SOME_ENV_VALUE: ${SOME_ENV_VALUE} \n"

sleep 1

echo -e "\nChecking DNS lookup ... \n"

nslookup github.com

if [ $? -ne 0 ]; then
  echo -e "DNS lookup failed!"
  exit 1
fi

echo -e "\nApp is exiting ... \n"

#exit 0;