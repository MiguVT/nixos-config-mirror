{ pkgs, ... }:

{
  hardware.openrazer.enable = true;
  hardware.openrazer.users = [ "miguvt" ];

  home-manager.users.miguvt.home.packages = with pkgs; [
    razergenie
  ];
}
