{ pkgs, ... }:

{
  # Game launchers and frontends; each one manages its own library.
  home-manager.users.miguvt.home.packages = [
    pkgs.gale
    pkgs.heroic
    pkgs.hydralauncher
    pkgs.hytale-launcher
    pkgs.lutris
    pkgs.pegasus-frontend
  ];
}
