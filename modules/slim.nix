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
}
