{ pkgs, ... }:

{
  home-manager.users.miguvt.home.packages = with pkgs; [
    onlyoffice-desktopeditors
    thunderbird
  ];
}
