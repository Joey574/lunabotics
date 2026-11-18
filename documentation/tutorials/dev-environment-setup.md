# VS Code Development Environment Setup

This tutorial explains how to install and configure Visual Studio Code (VS Code) for the Lunabotics project using any operating system, then setting up the IDE with Git, Pixi, and running ROS2.

Lines within a comment block indicate commands that should be entered into the specified CLI application.
```bash
cat Hello World!
```

## Prerequisites

- Terminal

## Table of contents

1. Install VS Code
2. Install Git
3. Install pixi
4. Set up pixi
5. Building the project

## Section 1 - Install VS Code

Skip this if you want to use a different editor of choice.

1. Open your terminal and run:

**windows**

```powershell
winget install -e --id Microsoft.VisualStudioCode
```

**mac**

```zsh
brew install --cask visual-studio-code
```

**linux**

Go to <https://code.visualstudio.com/docs/setup/linux>.

## Install needed extensions

1. Open VS Code.
2. Select **Extensions** from the Activity Bar or press `Ctrl+Shift+X`.
3. (Optional) install project-specific extensions such as **C/C++**.

## Recommended settings

Open Settings with `Ctrl+,` and enable **Format On Save** if the project provides a formatter. Keep project-specific settings in `.vscode/settings.json` so they can be shared with the team.

## Section 2 - Install Git

1. Download and install git.

**windows**

```powershell
winget install --id Git.Git
```

**mac**

```zsh
brew install git
```

**linux**

Every distro uses git as the package name:

```bash
sudo apt install git
```
2. On first use, set your Git identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```
3. Confirm the config values are accurate:

```bash
git config --global --list
```
4. (Optional) Choose a new default text editor for Git.

```bash
git config --global core.editor "C:/Path/To/Editor.exe"
```
5. On VS Code, open the Git Bash terminal from the 'Terminal' menu or with ''Ctrl+` `` and clone the repository:

```bash
git clone https://github.com/Joey574/lunabotics.git
git fetch
git pull
```

You will now have the lunabotics project code in your source control! VS Code will place you initially on the 'Main' branch. Main is a protected branch, meaning no one can push to it directly, all pushes must be reviewed by another member of the team before going into Main. You will need to checkout your own branch or switch to another branch to begin pushing commits.

```bash
git checkout -b yourname-dev
```

On your own branch you can commit freely without needing a review. When you want to commit your current work to your branch use:

```bash
git add .
git commit -m "some message"
```

Where the message should describe what work has been done during the commit. When you are ready to push to main use:

```bash
git push origin yourname-dev
```

Or alternatively start a pull request on the GitHub page. Make sure to always run `git pull` before each coding session to get the most up-to-date changes.

## Section 3 - Install pixi

### Windows

```powershell
winget install --id prefix-dev.pixi
```

### macOS

```zsh
brew install pixi
```

### Linux

Some distributions provide a specific package for Pixi:

```bash
emerge --ask pixi
```

On distributions that do not support this package, run:

```bash
curl -fsSL https://pixi.sh/install.sh | bash
```

## Section 4. Set up pixi in the project

From the root of your project, run:

```bash
pixi install
pixi shell
```

## Section 5. Build the package

Follow the build instructions for the specific package from the project root,
skipping the `/opt/*` source instructions.

## Troubleshooting

- **`code: command not found`:** Restart your terminal and VS Code, then verify that VS Code was installed with the PATH option enabled.

## Additional Resources

### Section 1:

### Section 2:

- <https://git-scm.com/book/en/v2/Getting-Started-Installing-Git>
- <https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup>
