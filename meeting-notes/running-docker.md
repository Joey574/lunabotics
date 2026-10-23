# Running Docker tips

## Zed

- Zed seems like it has builtin features for opening docker containers!

## Vscode

- For vscode you can use the [dev containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) to load the virtual file system and extensions. This will open a popup window in the bottom right asking if you want to open the container.
- Upon opening and building the container, the opened editor will act as if you open a `/workspace` folder, so your bash directory will be in `/workspace` and in the virtual file system. This means you can run `ros2`, `colcon` and other commands from inside the container.
- You can still open the folder and edit files with a normal vscode editor. If the permissions work correctly, you should be able to edit the same file in both editors and have the files sync.

Currently a workaround may be needed to launch vscode (Rather than opening vscode normally). This may be fixed by the next `chown`, since I have not had to do this again.
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

## Troubleshooting

- Note: Avoid changing the folder path after getting the docker working, since it breaks where the virtual fs is mounted!
- if you do accidentally do this and get a folder locked to your main user, you can run `sudo chown -R your-username folder-path` (if folder-path is in the pwd) to take ownership and delete it. Then change the folder path back to the original.
