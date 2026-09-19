{ inputs, ... }:

{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    extra-substituters = [
      "https://vicinae.cachix.org"
      "https://cuda-maintainers.cachix.org"
      "https://nixpkgs-xr.cachix.org"
    ];

    extra-trusted-public-keys = [
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "cuda-maintainers.cachix.org-1:0dq3bujK38/8qA3S4V0E9vS1y5R="
      "nixpkgs-xr.cachix.org-1:e1/s9jyDdy0gJgR32zZ2c2P8/GkXvJ="
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
