{ pkgs, ... }:

{
  home-manager.users.miguvt.home.packages = with pkgs; [
    sone
  ];
}
