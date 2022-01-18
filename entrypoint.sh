#!/bin/bash
set -xe

INPUT_GID=$(stat -c "%g" /dev/input/event0)
INPUT_GROUP_NAME=$(getent group $INPUT_GID | cut -d: -f1)
if ! id -G | grep -q $INPUT_GID; then
  if [ -z "$INPUT_GROUP_NAME" ]; then
    gname="input${INPUT_GID}"
    groupadd "$gname"
    groupmod -g "$INPUT_GID" "$gname"
  fi
  usermod -a -G "$gname" $USERNAME
fi

exec sleep infinity