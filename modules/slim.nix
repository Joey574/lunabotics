{ pkgs, ... }:

{
  # Exclude unused KDE default applications
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    oxygen
    krdp
    kgpg
    kmail
    kontact
    korganizer
    kaddressbook
    elisa
    kdenlive
    kwave
    kamoso
    kruler
    kcolorchooser
    kde-inotify-survey
    kate
    kwalletmanager
    qrca
    okular
    ark
    discover
    dolphin
    gwenview
    khelpcenter
    print-manager
    spectacle
  ];

  # Disable unused services
  services.printing.enable = false;
  services.avahi.enable = false;

  # Disable plasma wallet manager
  environment.etc."xdg/kwalletrc".text = ''
    [Wallet]
    Enabled=false
    First Use=false
  '';

  # More de bloat
  services.xserver.excludePackages = [ pkgs.xterm ];
  documentation.nixos.enable = false;
  programs.command-not-found.enable = false;
  boot.loader.timeout = 1;
}
