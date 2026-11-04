 # VS Code Development Environment Setup

This tutorial explains how to install and configure Visual Studio Code (VS Code) for the Lunabotics project using Ubuntu on WSL, then setting up the IDE with Git, Docker, and running ROS2.

Lines within a comment block indicate commands that should be entered into the specified CLI application.
```wsl
cat Hello World!
```

## Prerequisites

- Windows 10 or 11
- Ubuntu installed through WSL 2 (24.04 or 26.04)
- Git installed in Ubuntu

Check your WSL installation in PowerShell:

```powershell
wsl --status
```

Check your Ubuntu version in WSL:
```Ubuntu (WSL)
cat /etc/os-release
```

## Section 1 - Install VS Code

1. Download and install [Visual Studio Code](https://code.visualstudio.com/).
2. During installation, enable **Add to PATH** and **Add "Open with Code"** if available.
3. Open Ubuntu and verify that VS Code can be launched from WSL:

	```Ubuntu (WSL)
	code --version
	```

If `code` is not found, restart Ubuntu and VS Code.

## Install needed extensions

1. Open VS Code.
2. Select **Extensions** from the Activity Bar or press `Ctrl+Shift+X`.
3. Search and install the following extensions:
	- Docker by Microsoft
	- Dev Containers by Microsoft
4. (Optional) install project-specific extensions such as **C/C++**.

## Recommended settings

Open Settings with `Ctrl+,` and enable **Format On Save** if the project provides a formatter. Keep project-specific settings in `.vscode/settings.json` so they can be shared with the team.

## Section 2 - Install Git

1. Download and install [Git](https://git-scm.com/download/win).
2. On first use, set your Git identity:

```Git Bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```
3. Confirm the config values are accurate:

```Git Bash
git config --global --list
```
4. (Optional) Choose a new default text editor for Git.

```Git Bash
git config --global core.editor "C:/Path/To/Editor.exe"
```
5. On VS Code, open the Git Bash terminal from the 'Terminal' menu or with ''Ctrl+` `` and clone the repository:

```Git Bash
git clone https://github.com/Joey574/lunabotics.git
git fetch
git pull
```

Keep the repository in the Linux filesystem, such as `~/lunabotics`, instead of `/mnt/c`. You will now have the lunabotics project code in your source control! VS Code will place you initially on the 'Main' branch. Main is a protected branch, meaning no one can push to it directly, all pushes must be reviewed by another member of the team before going into Main. You will need to checkout your own branch or switch to another branch to begin pushing commits.

```Git Bash
git checkout -b yourname-dev
```

On your own branch you can commit freely without needing a review. When you want to commit your current work to your branch use:
```Git Bash
git add .
git commit -m "some message"
```

Where the message should describe what work has been done during the commit. When you are ready to push to main use:
```Git Bash
git push origin yourname-dev
```

Or alternatively start a pull request on the GitHub page. Make sure to always run `git pull` to get the most up-to-date changes.

## Configure the integrated terminal

Open the terminal with ``Ctrl+` `` and check the environment:

```Ubuntu (WSL)
pwd
git status
```

The path should be inside `~/lunabotics`, and Git should display the repository status.


## Troubleshooting

- **`code: command not found`:** Restart Ubuntu and VS Code, then verify that VS Code was installed with the PATH option enabled.
- **The folder opens in Windows instead of WSL:** Run `code .` from the Ubuntu terminal and select **WSL: Reopen Folder in WSL** from the Command Palette (`Ctrl+Shift+P`).
- **The project is slow:** Move it from `/mnt/c` into the WSL filesystem and reopen it from Ubuntu.
- **WSL is unavailable:** Run `wsl --update` in PowerShell and restart the computer.

## Additional Resources 
Section 1:

Section 2:
https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
