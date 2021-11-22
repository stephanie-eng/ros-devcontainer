source /etc/default/container-workspace-folder
cd $CONTAINER_WORKSPACE_FOLDER

INPUT_GID=$(stat -c "%g" /dev/input/event0)
INPUT_GROUP_NAME=$(getent group $INPUT_GID | cut -d: -f1)
if ! id -G | grep -q $INPUT_GID; then
  sudo usermod -a -G $INPUT_GID $(whoami)
  newgrp $INPUT_GROUP_NAME
fi
if [ -f /opt/ros/$ROS_DISTRO/setup.zsh ]; then
  . /opt/ros/$ROS_DISTRO/setup.zsh
fi

export PATH=/usr/lib/ccache:${PATH}