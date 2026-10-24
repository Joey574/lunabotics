# Running Docker tips

This document (WIP) contains tips for working with docker.

## Getting Started

Ensure that you have [docker engine](https://docs.docker.com/engine/install/) installed before proceeding.

After cloning the repo, you can start up the environment with `docker compose up`. On a fresh install, Docker will fetch the base image `ros:lyrical-ros-base-resolute` (~2.03GB) and build your local image, which may take several minutes.

```sh
cd .devcontainer
docker compose up -d    # -d is optional: runs in detached mode allowing you to continue using the terminal.
```

### Interacting with the Environment
Once the container is up and running, open an interactive terminal session inside it to start running ROS 2 commands:

```sh
docker compose exec -it ros2 bash   # ros2 is the service name in compose.yml
```

### Stopping the Environment
To stop the containers, run this command from the same folder:

```sh
docker compose down
```

(If not running in detached mode, press `Ctrl+C` in the process to gracefully shut down.)

## Zed

- Zed seems like it has builtin features for opening docker containers! (Todo)

## Vscode

After cloning the repo and running docker

## Misc

`docker system df` lists all the objects owned by docker, which is great for cleanup.

```sh
$ docker system df
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          1         1         2.028GB   0B (0%)
Containers      1         1         4.096kB   0B (0%)
Local Volumes   1         0         940MB     940MB (100%)
Build Cache     38        0         2.028GB   161kB
```
