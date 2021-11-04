ARG ROS_VERSION
FROM osrf/ros:${ROS_VERSION}-desktop

ARG WORKSPACE
ARG USERNAME=user

RUN set -xe; \
    adduser --gecos "" --disabled-password $USERNAME; \
    usermod -a -G sudo $USERNAME; \
    usermod -a -G video $USERNAME; \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudoers;

RUN set -xe; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get -y dist-upgrade; \
    apt-get install -y \
        clang-tidy \
        clang-tools \
        clang-format-10 \
        less \
        mesa-utils \
        nano \
        wget \
        zsh \
    ; \
    echo "export CONTAINER_WORKSPACE_FOLDER=${WORKSPACE}" > /etc/default/container-workspace-folder; \
    chsh -s /bin/zsh $USERNAME

COPY ros-activate.sh /etc/profile.d/ros-activate.sh

USER $USERNAME
COPY .zshrc /home/$USERNAME/.zshrc


