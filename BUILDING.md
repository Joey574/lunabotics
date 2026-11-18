# Building

This section explains how to set up your build environment for ROS 2.

## 1. Install Pixi

### Windows

```shell
winget install --id prefix-dev.pixi
```

### macOS

```shell
brew install pixi
```

### Linux

Some distributions provide a specific package for Pixi:

```shell
emerge --ask pixi
```

On distributions that do not support this package, run:

```shell
curl -fsSL https://pixi.sh/install.sh | bash
```

## 2. Set up the project

From the root of your project, run:

```shell
pixi install
pixi shell
```

## 3. Build the package

Follow the build instructions for the specific package from the project root,
skipping the `/opt/*` source instructions.