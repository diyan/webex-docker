#!/bin/bash
set -e

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$DIR"

# TODO grant access only to container instead of all local connections
xhost +local:
# Forcibly stop and remove old container
docker rm -f webex || true
docker build --tag=webex .
docker run --rm --name=webex -ti --volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
    --volume=/run/user/$UID/pulse/native:/run/pulse:ro \
    --env USER_ID="$UID" --env GROUP_ID="$GID" webex
