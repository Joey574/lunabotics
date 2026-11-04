# Lunabotics Mac Setup: ROS 2 Rolling in an Ubuntu VM (UTM)

This guide gets a Mac ready for development: an Ubuntu virtual machine running **ROS 2 Rolling**, plus Git, GitHub CLI, Docker, and VS Code.

> **Status:** The workflow was tested on an Intel Mac (macOS Monterey 12.7.6, UTM 5.0.8) with Ubuntu 24.04.4. The **Ubuntu 26.04 + ARM64 (Apple Silicon)** path below follows official documentation but has **not** been personally tested by the author. If a step fails, stop and ask for help with the exact error.

## Table of contents

1. [Before you start](#1-before-you-start)
2. [Install UTM](#2-install-utm-host)
3. [Download Ubuntu](#3-download-ubuntu-host)
4. [Create the VM](#4-create-the-vm-host)
5. [Install Ubuntu](#5-install-ubuntu-in-the-vm)
6. [Prepare Ubuntu](#6-prepare-ubuntu-guest)
7. [Git](#7-git-guest)
8. [GitHub CLI](#8-github-cli-guest)
9. [Docker Engine + Compose](#9-docker-engine--compose-guest)
10. [VS Code](#10-vs-code-guest)
11. [ROS 2 Rolling](#11-ros-2-rolling-guest)
12. [Test ROS](#12-test-ros-guest)
13. [Final verification](#13-final-verification-guest)
14. [Troubleshooting](#14-troubleshooting)
15. [Notes and limits](#15-notes-and-limits)
16. [Official sources](#16-official-sources)

## How to read this guide

| Label | Meaning |
|---|---|
| **(host)** | Done on your Mac, in macOS |
| **(guest)** | Done **inside the Ubuntu VM**, in the Ubuntu terminal |

Everything after VM creation runs **inside Ubuntu**, not in macOS Terminal. Open the Ubuntu terminal with `Ctrl+Alt+T`. When `sudo` asks for your password, **nothing appears as you type**. That is normal.

You do **not** need Homebrew, a USB stick, or an activation key.

> Never paste passwords, tokens, private keys, or login codes into chats or issues.

---

## 1. Before you start

**Check your processor:** Apple menu → **About This Mac**.

| Mac | Ubuntu ISO you need |
|---|---|
| Apple Silicon (M1, M2, M3, …) | **ARM64** (also called AArch64) |
| Intel | **AMD64** (also called x86_64) |

Using the wrong architecture will not work smoothly. Confirm before downloading.

**Suggested VM resources** (recommendations, not minimums; always leave enough for macOS):

| Your Mac | RAM | CPU cores | Virtual disk |
|---|---|---|---|
| 8 GB | 4096 MiB | 2 | 60 GB |
| 16 GB or more | 8192 MiB | 4 | 80 GB |

A 4096 MiB / 30 GB VM installed successfully for the original tester, but ROS builds and Docker images can use a lot of disk, so more disk is safer.

---

## 2. Install UTM (host)

1. Download UTM from <https://mac.getutm.app>.
2. Open the downloaded DMG and drag **UTM** into **Applications**.
3. Launch UTM.

## 3. Download Ubuntu (host)

Download the **Ubuntu 26.04 LTS Desktop** ISO matching your processor:

- **Apple Silicon (ARM64):** <https://cdimages.ubuntu.com/ubuntu/releases/26.04/release/>
- **Intel (AMD64):** <https://releases.ubuntu.com/26.04/>

Why 26.04? The current ROS 2 Rolling documentation lists **Ubuntu 26.04 (Resolute)** as the supported platform for Rolling, on both 64-bit x86 and 64-bit ARM. Rolling moves its target platform over time, so older Ubuntu versions (like 24.04) will show a warning that Rolling has migrated.

> Never edit Ubuntu repository codenames to make an older Ubuntu pretend to be a newer one.

## 4. Create the VM (host)

1. In UTM, click **+** → **Virtualize** → **Linux**.
2. Select the Ubuntu ISO you downloaded.
3. Set memory, CPU cores, and storage (see the table in section 1).
4. Save, then start the VM.
5. Keep the **default graphics settings** at first, especially on Apple Silicon.

## 5. Install Ubuntu in the VM

1. Follow the Ubuntu installer. Install onto the **virtual disk**. You are never erasing your Mac's physical disk.
2. Create an Ubuntu **username and password** and remember them.
3. When installation finishes, restart. When asked to remove the installation medium:
   - In UTM, **eject / clear the ISO** from the virtual CD/DVD drive.
   - Press **Return** inside the VM.
   - **Keep the virtual hard disk.**
4. If the installer already finished but keeps reappearing: stop the VM, clear the ISO in UTM, and start it again.

The installer can be slow. Progress matters more than the clock, so do not force-stop it just because it passed 15 minutes.

---

## 6. Prepare Ubuntu (guest)

```bash
sudo apt update
sudo apt upgrade
sudo apt install git curl ca-certificates software-properties-common
sudo add-apt-repository universe
sudo apt update
```

Restart Ubuntu if it asks you to.

## 7. Git (guest)

Git is local software; you do not need an account to use it. GitHub is a separate hosting service.

```bash
git --version
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

Replace the placeholders with your own details. These settings only **label** your commits; they do not log you in.

To keep your personal email private, copy the exact `noreply` address from GitHub → **Settings → Emails** and use it as `user.email`. Do not guess its format.

## 8. GitHub CLI (guest)

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
sudo chmod a+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
  | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

sudo apt update
sudo apt install gh
```

Log in:

```bash
gh auth login
```

Choose **GitHub.com**, **HTTPS**, say yes to authenticating Git, and pick **browser login**. Press **Enter** at the browser prompt, finish authorization in the browser, then **return to the terminal and wait for the shell prompt**. Do not type other commands while the login is still running.

Check:

```bash
gh auth status
```

If the browser says you are connected but the terminal seems stuck, open a **second** terminal and run `gh auth status` there. If you are not authenticated, press `Ctrl+C` in the old terminal and retry.

## 9. Docker Engine + Compose (guest)

Install Docker **inside Ubuntu**. You do not need Docker Desktop on macOS for this workflow.

> Before running this, quickly confirm that Docker's official Ubuntu instructions support your Ubuntu version: <https://docs.docker.com/engine/install/ubuntu/>. If `apt update` later complains that the Docker repository has no `Release` file for your Ubuntu codename, **stop and ask for help**. Do not change the codename.

```bash
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources > /dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo docker run hello-world
docker compose version
```

Use the modern `docker compose` (with a space), not the legacy `docker-compose`. If a project script needs the legacy command, check with whoever maintains it instead of installing another version blindly.

**Optional: run Docker without `sudo`**

```bash
sudo usermod -aG docker "$USER"
```

Log out and back in (or restart Ubuntu), then test `docker run hello-world`.

The `docker` group gives root-level power inside the VM. Using `sudo` instead is fine. Never make the Docker socket world-writable.

## 10. VS Code (guest)

```bash
sudo snap install code --classic
code
```

Open a project folder with `code .`. **Never run VS Code with `sudo`.** If the install fails, check that Snap supports your VM's architecture and report it.

## 11. ROS 2 Rolling (guest)

Follow the official ROS 2 Rolling installation instructions for Ubuntu (Debian packages), **step by step**:

**<https://docs.ros.org/en/rolling/Get-Started/Installation/Ubuntu-Install-Debs.html>**

Tips:

- Run every command **inside Ubuntu**, not in macOS Terminal.
- Rolling changes over time, so the official page is the source of truth. Follow it rather than copying commands from other places.
- Before you start, check your system. You should see Ubuntu **26.04**, and `arm64` (Apple Silicon) or `amd64` (Intel):

  ```bash
  cat /etc/os-release
  dpkg --print-architecture
  ```

- Install the **Desktop** variant, and the optional development tools if the page offers them.
- If a command fails, stop and read the exact error before continuing.
- After installing, open a new terminal and activate ROS:

  ```bash
  source /opt/ros/rolling/setup.bash
  echo "$ROS_DISTRO"
  ```

  You should see `rolling`. Sourcing configures the **current terminal only**, so repeat it in every new terminal, or add it to `~/.bashrc` once:

  ```bash
  grep -qxF 'source /opt/ros/rolling/setup.bash' ~/.bashrc \
    || echo 'source /opt/ros/rolling/setup.bash' >> ~/.bashrc
  ```

  Do not source more than one ROS distro in the same terminal.

---

## 12. Test ROS (guest)

### Talker / listener

**Terminal 1**

```bash
source /opt/ros/rolling/setup.bash
ros2 run demo_nodes_cpp talker
```

**Terminal 2**

```bash
source /opt/ros/rolling/setup.bash
ros2 run demo_nodes_py listener
```

The listener should print messages from the talker. Stop both with `Ctrl+C`.

### Turtlesim

Follow the official Turtlesim tutorial:

**<https://docs.ros.org/en/rolling/Get-Started/Introducing-Turtlesim/Introducing-Turtlesim.html>**

Remember to `source /opt/ros/rolling/setup.bash` in each new terminal first. If `ros2 pkg prefix turtlesim` later fails, install it with `sudo apt install ros-rolling-turtlesim`. The turtle should move when you drive it with the arrow keys.

---

## 13. Final verification (guest)

```bash
git --version
git config --global user.name
git config --global user.email
gh auth status
sudo docker run hello-world
docker compose version
code --version
echo "$ROS_DISTRO"
ros2 pkg prefix turtlesim
```

Also confirm manually:

- [ ] VS Code opens
- [ ] ROS talker and listener communicate
- [ ] Turtlesim moves

---

## 14. Troubleshooting

**A command failed.** Stop at that step and read the exact error before continuing. Post the full error text (not a screenshot of only the last line) when asking for help.

**Black screen during or after install.** First work out *when* it happens: during the installer, or after installation at login? When asking for help, include:

- ISO filename and architecture
- RAM and disk settings
- UTM version
- Graphics settings
- A screenshot

**Historical Intel-only workaround.** On one Intel Mac (UTM 5.0.8, `ubuntu-24.04.4-desktop-amd64.iso`, 4096 MiB RAM, 30 GB disk), both normal and safe-graphics boot showed the Ubuntu logo and then a black screen with a cursor. `virtio-vga` did not help. Choosing the display adapter **Spice QXL GPU (primary, vga compatible) (qxl-vga)** let the installation proceed. This is **not** a general recommendation, and especially not for Apple Silicon. Try the defaults first.

**Scrolling feels backwards.** Ubuntu **Settings → Mouse & Touchpad → Natural Scrolling**. If the VM treats your trackpad as a mouse, check the **Mouse** section.

---

## 15. Notes and limits

- **Architecture matters.** ARM64 and AMD64 binaries differ. Confirm that the project's container images and third-party libraries support your architecture before assuming something works.
- **Local tests are not robot tests.** Talker/listener and Turtlesim only prove ROS works inside your VM. Networking between the VM and the robot, `ROS_DOMAIN_ID`, middleware settings, and project repository setup are handled separately.
## 16. Official sources

- UTM install: <https://docs.getutm.app/installation/macos/>
- UTM Ubuntu guide (may show an older Ubuntu version): <https://docs.getutm.app/guides/ubuntu/>
- Ubuntu ARM64 releases: <https://cdimages.ubuntu.com/ubuntu/releases/26.04/release/>
- Ubuntu AMD64 releases: <https://releases.ubuntu.com/26.04/>
- GitHub CLI Linux install: <https://github.com/cli/cli/blob/trunk/docs/install_linux.md>
- GitHub CLI login: <https://cli.github.com/manual/gh_auth_login>
- GitHub CLI status: <https://cli.github.com/manual/gh_auth_status>
- Git commit identity: <https://docs.github.com/en/get-started/git-basics/setting-your-username-in-git>
- Docker on Ubuntu: <https://docs.docker.com/engine/install/ubuntu/>
- Docker post-install: <https://docs.docker.com/engine/install/linux-postinstall/>
- Docker Compose plugin: <https://docs.docker.com/compose/install/linux/>
- VS Code on Linux: <https://code.visualstudio.com/docs/setup/linux>
- ROS 2 Rolling on Ubuntu: <https://docs.ros.org/en/rolling/Get-Started/Installation/Ubuntu-Install-Debs.html>
- Turtlesim tutorial: <https://docs.ros.org/en/rolling/Get-Started/Introducing-Turtlesim/Introducing-Turtlesim.html>
