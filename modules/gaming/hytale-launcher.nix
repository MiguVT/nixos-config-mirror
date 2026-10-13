{ pkgs, inputs, ... }:
{
  home-manager.users.miguvt.home.packages = [
    (inputs.hytale-launcher-flake.packages.${pkgs.stdenv.hostPlatform.system}.default)
  ];
}