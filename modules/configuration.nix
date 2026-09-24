# This file defines the configuration for the mission control systems
# It's primary goal is to allow operators during the competition to have
# a low latency and stable environment to operate in

{ config, lib, pkgs, ... }:

{
  imports = [
    ./slim.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use zen kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Kernel parameters
  boot.kernelParams = [
    "preempt=full"
    "threadirqs" 	# Pin IRQ handler to a thread, helps with scheduling
    "quiet"
    "mitigations=off" 	# Disable mitigations like spectre/meltdown, isolated competition hardware doesn't need it

    # Below commands isolate cores at idx 0-1 from the kernel
    # preventing interupts or other events from happening on them
    # This allows us to pin our own proccess on these cores and get
    # much higher realtime performance / lower latency
    "nohz_full=0-1"
    "rcu_nocbs=0-1"
    "isolcpus=0-1"

    # Enable watchdog to prevent kernel hang
    "nmi_watchdog=1"
  ];

  powerManagement.cpuFreqGovernor = "performance";

  # Set up graphical environment
  services.xserver.videoDrivers = [ "modesetting" ];
  services.xserver.enable = true;

  # Set up KDE Plasma
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = false;
  };
  services.desktopManager.plasma6.enable = true;

  # Disable system sleep
  systemd.sleep.settings = {
    Sleep = {
      AllowSuspend = "no";
      AllowHibernation = "no";
      AllowHybridSleep = "no";
      AllowSuspendThenHibernate = "no";
    };
  };

  # Enable auto-login for admin
  services.displayManager.autoLogin = {
    enable = true;
    user = "admin";
  };

  # Tune sysctl
  boot.kernel.sysctl = {
    "net.ipv4.tcp_nodelay" = 1;
    "net.ipv4.tcp_low_latency" = 1;
    "kernel.sched_rt_runtime_us" = -1;
  };

  networking.hostName = "nixos";

  # Make /tmp a tmpfs -> stored in RAM
  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "2G";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Users
  users.users = {
    admin = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    git
    htop
    btop
    iotop
    nethogs
    tcpdump
    strace
    lsof
    iproute2
    ethtool
    pciutils
    usbutils
    nmap
    sysstat
    lm_sensors

    linuxPackages.perf

    kdePackages.konsole
    kdePackages.ksystemlog
    kdePackages.plasma-systemmonitor
  ];

  # Disable plasma wallet manager
  environment.etc."xdg/kwalletrc".text = ''
    [Wallet]
    Enabled=false
    First Use=false
  '';

  # Enable the OpenSSH daemon
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  # Competition Software
  #systemd.services.mission-control = {
  #  description = "Lunabotics Mission Control suite";
  #  wantedBy = [ "multi-user.target" ];
  #  after = [ "network.target" ];
  #  serviceConfig = {
  #    ExecStart = "";
  #    WatchdogSec = "10s";
  #    Restart = "on-failure";
  #    RestartSec = "1s";
  #    Nice = "-10";
  #    CPUSchedulingPolicy = "rr";
  #    CPUSchedulingPriority = 80;
  #    CPUAffinity = "2-3";
  #    LimitMEMLOCK = "infinity";
  #  };
  #};

  # Journalctl logging config
  # Persistent storage allows us to inspect logs after reboot
  # rest of the params just limit resource usage
  services.journald.extraConfig = ''
    SystemMaxUse=500M
    RuntimeMaxUse=100M
    Storage=persistent
    Compress=yes

    # Forward to remote logging pipeline
    ForwardToSyslog=yes
  '';

  # CPU logging (10s interval by default)
  services.sysstat.enable = true;

  # Local packet capture
  systemd.services.pakcet-capture = {
    description = "capture packets for logging";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.tcpdump}/bin.tcpdump -i any -C 100 -W 10 -n -s 0 -w /var/log/pcap/capture.pcap";
      Restart = "on-failure";
    };

    preStart = "mkdir -p /var/log/pcap";
  };

  # Local disk i/o
  systemd.services.iostat-logger = {
    description = "log disk i/o";

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.sysstat}/bin/iostat -x 1 5 >> /var/log/iostat.log";
    };
  };

  # Run i/o logging on timer
  systemd.timer.iostat-logger = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalender = "*:*:0/10";
      Persistent = true;
    };
  };

  system.stateVersion = "26.05";
}
