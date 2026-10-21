FROM ros:lyrical-ros-base-resolute

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash-completion \
    build-essential \
    ca-certificates \
    clang \
    clangd \
    clang-format \
    clang-tidy \
    cmake \
    curl \
    gdb \
    git \
    less \
    ninja-build \
    python3-argcomplete \
    python3-colcon-common-extensions \
    python3-pip \
    python3-rosdep \
    python3-venv \
    python3-vcstool \
    ros-lyrical-rmw-cyclonedds-cpp \
    sudo \
    wget \
    && rm -rf /var/lib/apt/lists/*

ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid "${USER_GID}" "${USERNAME}" \
    && useradd --uid "${USER_UID}" --gid "${USER_GID}" \
        --create-home --shell /bin/bash "${USERNAME}" \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" \
        > "/etc/sudoers.d/${USERNAME}" \
    && chmod 0440 "/etc/sudoers.d/${USERNAME}" \
    && if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then rosdep init; fi

RUN printf '%s\n' \
    'source /opt/ros/lyrical/setup.bash' \
    'if [ -f /workspace/install/setup.bash ]; then source /workspace/install/setup.bash; fi' \
    >> "/home/${USERNAME}/.bashrc" \
    && chown "${USERNAME}:${USERNAME}" "/home/${USERNAME}/.bashrc"

WORKDIR /workspace

USER ${USERNAME}

CMD ["sleep", "infinity"]
