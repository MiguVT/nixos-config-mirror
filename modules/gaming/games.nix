{ pkgs, ... }:

{
  # Standalone games packaged in nixpkgs; they need no launcher.
  home-manager.users.miguvt.home.packages = [
    pkgs.mari0
    pkgs.sm64coopdx
  ];
}
