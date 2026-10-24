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
docker compose exec -it ros2 bash   # 'ros2' is the service name defined in compose.yml
```

To stop the containers, run this command from the same directory:

```sh
docker compose down
```

*(Note: If not running in detached mode, you can press `Ctrl+C` in the terminal window to gracefully stop the container.)*

## Zed

- Zed seems like it has builtin features for opening docker containers! (Todo)


## [Vscode in a Docker container](https://code.visualstudio.com/docs/devcontainers/tutorial)

Warning: This section is WIP and not recommended at the moment.

- For vscode you can use the [dev containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) to load the virtual file system and extensions. This will open a popup window in the bottom right asking if you want to open the container.
- Upon opening and building the container, the opened editor will act as if you open a `/workspace` folder, so your bash directory will be in `/workspace` and in the virtual file system. This means you can run `ros2`, `colcon` and other commands from inside the container.
- You can still open the folder and edit files with a normal vscode editor. If the permissions work correctly, you should be able to edit the same file in both editors and have the files sync.

Currently a workaround may be needed to launch vscode. This may be fixed by the `chown` command in the next step.
```sh
# Linux:
export BUILDX_BAKE_ENTITLEMENTS_FS=0
code /path-to-lunabotics-folder

# Windows equivalent:
$env:BUILDX_BAKE_ENTITLEMENTS_FS="0"
code .
```
Also if you cannot edit files inside the virtual fs,  you may have to run a command in the virtual bash to take ownership:
```
sudo chown -R $(whoami) /workspace
```

- Note: Avoid changing the folder path after getting the docker working, since it breaks where the virtual fs is mounted!
- if you do accidentally do this and get a folder locked to your main user, you can run `sudo chown -R your-username folder-path` (if folder-path is in the pwd) to take ownership and delete it. Then change the folder path back to the original.


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
