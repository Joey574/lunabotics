# Running Docker tips

This document (WIP) contains notes on working with docker.

## Getting Started

Ensure that you have [docker engine](https://docs.docker.com/engine/install/) installed before proceeding.

After cloning the repo, you can start up the environment with `docker compose up`. On a fresh install, Docker will fetch the base image `ros:lyrical-ros-base-resolute` (~2.03GB) and build your local image, which may take several minutes.

```sh
cd .devcontainer
docker compose up -d    # -d is optional: runs in detached mode so you can keep using your terminal.
```

Once the container is up and running, open an interactive terminal session inside it to start running ROS 2 commands:

```sh
docker ps # this lists out all the running containers along with their names

docker exec -it 'name' bash   # 'name' here is the name of the container on your machine
```

To stop the containers, run this command from the same directory:

```sh
docker compose down
```

_(Note: If not running in detached mode, you can press `Ctrl+C` in the terminal window to gracefully stop the container.)_

## Zed

- Zed seems like it has builtin features for opening docker containers! (Todo)

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
