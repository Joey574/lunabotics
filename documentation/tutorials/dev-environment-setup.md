 # VS Code Development Environment Setup

This tutorial explains how to install and configure Visual Studio Code (VS Code) for the Lunabotics project using Ubuntu on WSL, then setting up the IDE with Git, Docker, and running ROS2.

Lines within a comment block indicate commands that should be entered into the specified CLI application.
```wsl
cat Hello World!
```

## Prerequisites

- Windows 11

## Table of contents
1. Install VS Code
2. Install Git
3. Install WSL
4. Install ROS2

## Section 1 - Install VS Code

1. Download and install [Visual Studio Code](https://code.visualstudio.com/).
2. During installation, enable **Add to PATH** and **Add "Open with Code"** if available.
3. Open Ubuntu and verify that VS Code can be launched from WSL:

	```Ubuntu (WSL)
	code --version
	```

- If `code` is not found, restart Ubuntu and VS Code.

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

Or alternatively start a pull request on the GitHub page. Make sure to always run `git pull` before each coding session to get the most up-to-date changes.

## Section 3 - Intall WSL

1. Open PowerShell or Command Prompt as an Administrator, and run the following command to install WSL and the default Ubuntu distribution:

```powershell
wsl --install -d Ubuntu-26.04
```
Once the installation completes, restart your computer if prompted.
In the future you can always check the WSL version with this command:

```wsl
cat /etc/os-release
```

2. Launch Ubuntu from the Windows Start menu or run `wsl` in terminal. Create a UNIX username and password when prompted.

3. Set Up Locale

```wsl
locale
sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
locale 
```
The final command should return:

```
LANG=en_US.UTF-8
LANGUAGE=
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_ALL=
```


```wsl
sudo apt update && sudo apt upgrade -y
```

4. Setup Software Repositories

- Add the ROS 2 GPG key and APT repository, and enable the Ubuntu Universe repository:

```wsl
sudo apt install software-properties-common
sudo add-apt-repository universe
```
- Then download and add the GPG key:

```wsl
sudo apt update && sudo apt install curl -y
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F'"' '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb"
sudo dpkg -i /tmp/ros2-apt-source.deb
```

- Finally, add the repository to your sources list:

```wsl
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
```

5. Install ROS 2 Packages

Ensure system is up to date: 

```wsl
sudo apt update
sudo apt upgrade
```
Now install ROS 2 Desktop (includes ROS, RViz, demos, and tutorials):

```wsl
sudo apt install ros-lyrical-desktop
source /opt/ros/lyrical/setup.bash
```

Test the install with some built-in examples:
```wsl
source /opt/ros/lyrical/setup.bash
ros2 run demo_nodes_cpp talker
```

Open another terminal and run the listener:
```wsl
source /opt/ros/lyrical/setup.bash
ros2 run demo_nodes_py listener
```

6. Enable GUI Support (WSLg)

WSL 2 on Windows 11 natively supports graphical Linux applications (WSLg), which is critical for ROS 2 tools like RViz and Gazebo.
To ensure your display drivers and utilities are up to date:

```wsl
sudo apt install -y mesa-utils libgl1-mesa-dri
```
Then test GUI functionality by running:

```wsl
glxgears
```
(A small window with turning gears should appear).

## Section 4 - Install Turtlesim

1. Install Turtlesim 

```wsl
sudo apt update
sudo apt install ros-lyrical-turtlesim
ros2 pkg executables turtlesim
```

The output should list Turtlesim’s executables:

```
turtlesim draw_square
turtlesim mimic
turtlesim turtle_teleop_key
turtlesim turtlesim_node
```

2. Test Turtlesim

```wsl
ros2 run turtlesim turtlesim_node
```

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
