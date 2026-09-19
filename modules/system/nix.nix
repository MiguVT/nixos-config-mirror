{ inputs, ... }:

{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    extra-substituters = [
      "https://vicinae.cachix.org"
      "https://cache.nixos-cuda.org"
    ];

    extra-trusted-public-keys = [
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];

    auto-optimise-store = true;
  };

  nix.registry.nixpkgs.flake = inputs.nixpkgs;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
}
