{ ... }:

{
  home-manager.users.miguvt = { pkgs, ... }: {
    home.packages = with pkgs; [
      vesktop
      telegram-desktop
    ];
  };
}
