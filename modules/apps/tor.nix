{ ... }:

{
  services.tor.enable = true;

  home-manager.users.miguvt = { pkgs, ... }: {
    home.packages = with pkgs; [
      tor-browser
    ];
  };
}
