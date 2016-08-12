#!/usr/bin/env bash

dockerd-entrypoint.sh &> /dev/null &
echo "waiting for docker daemon"
sleep 5

cd compose

docker-compose up