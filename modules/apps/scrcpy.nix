{ pkgs, ... }:

{
  home-manager.users.miguvt.home.packages = with pkgs; [
    scrcpy
    kdePackages.kdeconnect-kde
  ];
}
