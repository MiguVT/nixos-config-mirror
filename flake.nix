{
  description = "MiguVT's NixOS Modular Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    millennium = {
      url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    freesmlauncher = {
      url = "github:FreesmTeam/FreesmLauncher?ref=develop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mocktail = {
      url = "github:komaruworld/mocktail";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-xr,
      nix-flatpak,
      home-manager,
      vicinae,
      vicinae-extensions,
      freesmlauncher,
      millennium,
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
              (final: _prev: {
                stable = import inputs.nixpkgs-stable {
                  system = final.system;
                  config = final.config;
                };
              })
            ];
          }

          ./configuration.nix
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
              ];
              home.stateVersion = "24.11";
            };
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
}
