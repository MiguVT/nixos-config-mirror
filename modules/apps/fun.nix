{ pkgs, ... }:

{
  home-manager.users.miguvt.home.packages = [
    pkgs.activate-linux
  ];
}
