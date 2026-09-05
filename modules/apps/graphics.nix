{ pkgs, ... }:

{
  home-manager.users.miguvt = {
    home.packages = with pkgs; [
      gimp-with-plugins
    ];
  };
}
