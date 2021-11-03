source /etc/default/container-workspace-folder
cd $CONTAINER_WORKSPACE_FOLDER

ROS_DISTRO=foxy

if [ -f /opt/ros/$ROS_DISTRO/setup.zsh ]; then
  . /opt/ros/$ROS_DISTRO/setup.zsh
fi
