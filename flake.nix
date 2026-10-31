{
  description = "MiguVT's NixOS Modular Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";

    vicinae.url = "github:vicinaehq/vicinae";

    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    freesmlauncher = {
      url = "github:FreesmTeam/FreesmLauncher?ref=develop";
    };

    mocktail.url = "github:komaruworld/mocktail";

    creamlinux-installer = {
      url = "github:Novattz/creamlinux-installer";
      flake = false;
    };

    amethyst = {
      url = "github:ChrisDKN/Amethyst-Mod-Manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hytale-launcher-flake = {
      url = "github:visoredkon/hytale-launcher-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-xr,
      nix-flatpak,
      home-manager,
      vicinae,
      sops-nix,
      ...
    }@inputs:
    {
      devShells.x86_64-linux.default =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in
        pkgs.mkShell {
          packages = [
            pkgs.nil
            pkgs.nixfmt
            pkgs.sops
            pkgs.age
            pkgs.ssh-to-age
          ];
        };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          { nixpkgs.hostPlatform = "x86_64-linux"; }

          # Overlay exposing pkgs.stable globally
          {
            nixpkgs.overlays = [
              (_final: _prev: {
                stable = inputs.nixpkgs-stable.legacyPackages."x86_64-linux";
              })

              # Exposes pkgs.hytale-launcher (unfree; allowed via allowUnfreePredicate)
              inputs.hytale-launcher-flake.overlays.default
            ];
          }

          ./configuration.nix
          sops-nix.nixosModules.sops
          nix-flatpak.nixosModules.nix-flatpak
          nixpkgs-xr.nixosModules.nixpkgs-xr

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.miguvt = {
              imports = [
                vicinae.homeManagerModules.default
                ./modules/home/vr.nix
                ./modules/home/gaming.nix
              ];
              home.stateVersion = "24.11";
            };
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
}
