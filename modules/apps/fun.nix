{ pkgs, ... }:

{
  home-manager.users.miguvt.home.packages = [
    pkgs.activate-linux
    pkgs.charm-freeze
    pkgs.fastfetch
    pkgs.hyfetch
  ];
}
