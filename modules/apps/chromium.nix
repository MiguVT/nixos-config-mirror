{ pkgs, ... }:

{
  home-manager.users.miguvt = {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
    };
  };
}
