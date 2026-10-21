#!/usr/bin/env bash
set -euo pipefail

source /opt/ros/lyrical/setup.bash
cd /workspace

echo 'Updating rosdep database...'
rosdep update

if [ -d src ] && find src -name package.xml -print -quit | grep -q .; then
    echo 'Installing ROS package dependencies...'

    sudo rosdep install \
        --from-paths src \
        --ignore-src \
        --rosdistro lyrical \
        -y
else
    echo 'No ROS packages found under src/; skipping dependency install.'
fi

echo 'ROS 2 development container is ready.'
