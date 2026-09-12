{ pkgs, inputs, ... }:

{
  services.flatpak.packages = [
    "org.vinegarhq.Sober"
    # Reuses the Roblox Android build downloaded by Sober; ships no Roblox code itself.
    { appId = "io.github.luohoa97.Cordial"; origin = "cordial"; }
  ];

  environment.systemPackages = [
    # Pinned via flake.lock; see inputs.mocktail in flake.nix.
    inputs.mocktail.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
