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
        ccache \
        clang-tidy \
        clang-tools \
        clang-format-10 \
        less \
        mesa-utils \
        nano \
        python3-pip \
        python3-sphinx \
        wget \
        xdg-utils \
    ; \
    pip3 install pre-commit ; \
    echo "export CONTAINER_WORKSPACE_FOLDER=${WORKSPACE}" > /etc/default/container-workspace-folder; \
    chsh -s /bin/bash $USERNAME

COPY ros-activate.sh /etc/profile.d/ros-activate.sh

ENV USERNAME=$USERNAME
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
