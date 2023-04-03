#!/bin/bash
set -xe

# Only do this if /dev/input/event0 exists, requires container to be priveledged
if [ -f /dev/input/event0 ]; then
    # Get GID and group name of /dev/input/event0
    INPUT_GID=$(stat -c "%g" /dev/input/event0)
    INPUT_GROUP_NAME=$(getent group $INPUT_GID | cut -d: -f1)

    # If group does not exist, create it
    if [ -z "$INPUT_GROUP_NAME" ]; then
        gname="input${INPUT_GID}"
        groupadd "$gname"
        groupmod -g "$INPUT_GID" "$gname"
    fi

    # Add the container to the input group
    usermod -a -G "$gname" $USERNAME
fi

exec sleep infinity
