source /etc/default/container-workspace-folder
cd $CONTAINER_WORKSPACE_FOLDER

if [ -f /opt/ros/$ROS_DISTRO/setup.zsh ]; then
  . /opt/ros/$ROS_DISTRO/setup.zsh
fi

export HISTFILE=$CONTAINER_WORKSPACE_FOLDER/.devcontainer/zsh_history
export PATH=/usr/lib/ccache:${PATH}
export ROS_DOMAIN_ID=11
export RCUTILS_COLORIZED_OUTPUT=1