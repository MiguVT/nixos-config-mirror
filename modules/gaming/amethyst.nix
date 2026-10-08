{ pkgs, inputs, ... }:

{
  home-manager.users.miguvt.home.packages = [
    # Pinned via flake.lock; see inputs.amethyst in flake.nix.
    inputs.amethyst.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
