{ pkgs, inputs, ... }:

{
  services.flatpak.packages = [
    "org.vinegarhq.Sober"
  ];

  environment.systemPackages = [
    # Pinned via flake.lock; see inputs.mocktail in flake.nix.
    inputs.mocktail.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
