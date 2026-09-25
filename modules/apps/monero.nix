{ ... }:

{
  home-manager.users.miguvt = { pkgs, ... }: {
    home.packages = with pkgs; [
      monero-gui
    ];
  };
}
