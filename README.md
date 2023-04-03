# ros-devcontainer

To use this devcontainer, clone this repository into your workspace, and rename the folder to `.devcontainer`. In the case where this repository will be used as part of another git repository, add the .devcontainer folder to .git/info/exclude (which works like a local .gitignore to avoid having these files included.

## ROS version

To use a different ROS version, change the `ROS_VERSION` (in build args) and the `ROS_DISTRO` (in run args) in `devcontainer.json`. For conveniece, branches exist for the following:
 - Melodic
 - Galactic
 - Foxy
 - Rolling (master)

## Quick Start with VSCode

Install VSCode and the "Remote Containers Extension". Open the parent folder of `.devcontainer`. VSCode should prompt if you would like to re-open the container. Do so, and you are good to go. You can open a terminal with ``Ctrl + ` ``.

## Working from the container

The parent folder of this `.devcontainer` is shared into the container's workspace, so put your source files there. You can also get there with the CONTAINER_WORKSPACE_FOLDER environment variable (`cd $CONTAINER_WORKSPACE_FOLDER`). The typical directory structure looks like this:

```
    workspace/.devcontainer
    workspace/src/your_code_here
```

## ros-activate.sh
This file is copied to the container's `/etc/profile.d` for convenience. It sets up the ROS environment and some helpful environmental variables.

## entrypoint.sh
This is the script that runs as the Docker entrypoint. It modifies some user permissions to allow the use a joystick in the container. ROS2 uses `/dev/input/event*` for the joystick - the default user in the container does not have read access to this. To correct the user permissions, the entrypoint finds the group that owns the file, and adds the current user to that group.

## Notes
Create the ccache folder manually from outside the container, or suffer user permission errors.

If Docker creates the folder it will be owned by root:root and ccache will not have permission to run. To fix this, make the ccache folder in the workspace before using or run the following command from inside the container.

```
sudo chown user:user /home/user/.ccache
```
