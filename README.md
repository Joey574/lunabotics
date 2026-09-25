# Mission Control for Lunabotics BC

## Development
Start your environment by running
```bash
git clone https://github.com/Joey574/lunabotics
```
this downloads all the files you'll need locally, you can then move into that project directory with
```bash
cd ./lunabotics
```

Main is a protected branch, meaning no one can push to it directly, all pushes must be reviewed by another member of the team before going into main, for quick development I recommend running
```bash
git checkout -b yourname-dev
```

This gives you your own branch to freely develop on without needed reviews for each push, when you're ready to commit something to main, you can open up github via the browser and it will prompt you to create a pull request

The main commands you are going to need for git are the following
```bash
# stages and commits all the uncommited local changes
git add .
git commit -m "some message"

# push sends local commits up to the cloud
# pull will bring them down
git push origin yourname-dev
git pull origin yourname-dev

# you use checkout to switch between branches
git checkout main
git checkout yourname-dev
```

## Setup
First you need to install wsl if on windows, if you're on linux or mac, skip to the next step

Install nix
```bash
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon

sudo apt update
sudo apt install nix-bin
```

verify your installation with
```bash
nix-env --version
```

enable experimental features
```bash
sudo mkdir -p /etc/nix
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
```

restart your shell then verify with
```bash
nix flake --version
```

to build the test environment run the follwing, make sure you are charging your computer and are comfy, this will start a multi giga byte download
```bash
sudo nix build .#checks.x86_64-linux.interactive-test.driverInteractive
```
