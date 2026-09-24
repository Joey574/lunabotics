# Mission Control for Lunabotics BC

### Setup
First you need to install wsl if on windows, if you're on linux or mac, skip to the next step

Install nix
```bash
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon
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

to build the test environment run
```bash
sudo nix build .#checks.x86_64-linux.interactive-test.driverInteractive
```
