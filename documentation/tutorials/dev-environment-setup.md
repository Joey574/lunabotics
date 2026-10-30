 # VS Code Development Environment Setup

This tutorial explains how to install and configure Visual Studio Code (VS Code) for the Lunabotics project using Ubuntu on WSL.

## Prerequisites

- Windows 10 or 11
- Ubuntu installed through WSL 2
- Git installed in Ubuntu

Check your WSL installation in PowerShell:

```powershell
wsl --status
```

## Install VS Code

1. Download and install [Visual Studio Code](https://code.visualstudio.com/).
2. During installation, enable **Add to PATH** and **Add "Open with Code"** if available.
3. Open Ubuntu and verify that VS Code can be launched from WSL:

	```bash
	code --version
	```

If `code` is not found, restart Ubuntu and VS Code.

## Install the WSL extension

1. Open VS Code.
2. Select **Extensions** from the Activity Bar or press `Ctrl+Shift+X`.
3. Search for **WSL** and install the extension published by Microsoft.
4. Optionally install project-specific extensions such as **Python** or **C/C++**.

## Open the project in WSL

Open Ubuntu and run:

```bash
cd ~/lunabotics
code .
```

If VS Code asks how to open the folder, choose **Reopen Folder in WSL**. The bottom-left corner should display **WSL: Ubuntu**.

Keep the repository in the Linux filesystem, such as `~/lunabotics`, instead of `/mnt/c` for better performance.

## Configure the integrated terminal

Open the terminal with ``Ctrl+` `` and check the environment:

```bash
pwd
git status
```

The path should be inside `~/lunabotics`, and Git should display the repository status.

## Configure Git

On first use, set your Git identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

Confirm the values:

```bash
git config --global --list
```

## Recommended settings

Open Settings with `Ctrl+,` and enable **Format On Save** if the project provides a formatter. Keep project-specific settings in `.vscode/settings.json` so they can be shared with the team.

## Troubleshooting

- **`code: command not found`:** Restart Ubuntu and VS Code, then verify that VS Code was installed with the PATH option enabled.
- **The folder opens in Windows instead of WSL:** Run `code .` from the Ubuntu terminal and select **WSL: Reopen Folder in WSL** from the Command Palette (`Ctrl+Shift+P`).
- **The project is slow:** Move it from `/mnt/c` into the WSL filesystem and reopen it from Ubuntu.
- **WSL is unavailable:** Run `wsl --update` in PowerShell and restart the computer.
