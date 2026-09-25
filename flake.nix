{
  description = "lunabotics";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      lib = nixpkgs.lib;
    in
    {
      packages.${system}.lunabotics = pkgs.buildGoModule {
        pname = "lunabotics";
        version = "0-unstable";
        src = ./.;

        proxyVendor = true;
        vendorHash = "sha256-d6VT1kKHT2BWWfY8JsIv27Tfdpr75fUIl8gIO1cmojE=";
        #vendorHash = lib.fakeHash;

        nativeBuildInputs = with pkgs; [
          pkg-config
        ];

        buildInputs = with pkgs; [
          libGL
          libX11
          libxcursor
          libxrandr
          libxinerama
          libxi
          libxxf86vm
          wayland
          wayland-protocols
          libxkbcommon
        ];
      };

      checks.${system}.interactive-test = pkgs.testers.runNixOSTest {
        name = "interactive-test";

        nodes = {
          op1 = { pkgs, ... }: {
            imports = [ ./modules/configuration.nix ];
            virtualisation.useNixStoreImage = true;
            environment.systemPackages = [ self.packages.${system}.lunabotics ];
            _module.args.lunabotics = self.packages.${system}.lunabotics;
          };
        };

        testScript = ''
          start_all()
          op1.succeed("ldd $(readlink -f /run/current-system/sw/bin/sddm) | grep 'not found'")
          op1.wait_for_unit("multi-user.target")
          op1.wait_for_unit("display-manager.service")
          op1.sleep(3)
        '';
      };
    };
}
