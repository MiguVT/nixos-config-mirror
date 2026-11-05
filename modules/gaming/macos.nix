{ pkgs, inputs, ... }:

{
  home-manager.users.miguvt.home.packages = [
    # Butter is the prefix/runtime manager for Rosemary, the macOS
    # compatibility layer. It downloads the prebuilt Rosemary runners, which
    # are prebuilt binaries and therefore rely on nix-ld
    # (modules/system/nix-ld.nix).
    inputs.butter.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
