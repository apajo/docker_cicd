#!/bin/sh

echo -e "\nApp is running ... \n"

sleep 3

echo -e "\Environment variable VERSION: $VERSION \n"
echo -e "\Environment variable SOME_ENV_VALUE: $SOME_ENV_VALUE \n"

sleep 1

echo -e "\nApp is exiting ... \n"

sleep 2

exec "$@"