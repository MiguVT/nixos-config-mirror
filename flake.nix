{
  description = "MiguVT's NixOS Modular Flake";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    # Desktop shell
    vicinae.url = "github:vicinaehq/vicinae";

    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # VR
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

    # Gaming
    briar = {
      url = "git+https://git.miguvt.com/MiguVT/Briar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    butter.url = "github:microlift/butter";

    amethyst = {
      url = "github:ChrisDKN/Amethyst-Mod-Manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    creamlinux-installer = {
      url = "github:Novattz/creamlinux-installer";
      flake = false;
    };

    freesmlauncher.url = "github:FreesmTeam/FreesmLauncher?ref=develop";

    hytale-launcher-flake = {
      url = "github:visoredkon/hytale-launcher-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";

    mocktail.url = "github:komaruworld/mocktail";

    yapfast.url = "github:yapfast/yapfast";
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
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      formatter.x86_64-linux = pkgs.nixfmt;

      devShells.x86_64-linux.default = pkgs.mkShell {
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

              # ALCOM (vrc-get), Gale, Pandora Launcher, Heroic and HydraLauncher
              # vendor aws-lc-sys, but nixpkgs' cargo-setup-hook forces
              # AWS_LC_SYS_USE_SYSTEM=1 (system AWS-LC), which isn't available
              # in the sandbox. Opt out so aws-lc-sys builds from source.
              (_final: _prev: {
                alcom = _prev.alcom.overrideAttrs (old: {
                  dontCargoUseSystemLibs = true;
                });
                gale = _prev.gale.overrideAttrs (old: {
                  dontCargoUseSystemLibs = true;
                });
                pandora-launcher-unwrapped = _prev.pandora-launcher-unwrapped.overrideAttrs (old: {
                  dontCargoUseSystemLibs = true;
                });
                heroic = _prev.heroic.overrideAttrs (old: {
                  dontCargoUseSystemLibs = true;
                });
                hydralauncher = _prev.hydralauncher.overrideAttrs (old: {
                  dontCargoUseSystemLibs = true;
                });
              })
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
                ./modules/home/emulators.nix
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
