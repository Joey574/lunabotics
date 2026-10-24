# Running Docker tips

This document (WIP) contains tips for working with docker.

## Getting Started

Ensure that you have [docker engine](https://docs.docker.com/engine/install/) installed before proceeding.

After cloning the repo, you will need to build the image. This will fetch the base image `ros:lyrical-ros-base-resolute` (~2.03GB) and build it, which may take several minutes. It is recommended to stay in the root folder and not `cd` into `.devcontainer` for building. Run the build command from `compose.yml`:

```sh
docker compose -f .devcontainer/compose.yml build
```

Once it finishes, you can run the `ros2` service defined in `compose.yml`.
```sh
cd .devcontainer
docker compose up
```

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
