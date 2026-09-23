{ pkgs, ... }:

{
  home-manager.users.miguvt.home.packages = [
    pkgs.hydralauncher
  ];
}
