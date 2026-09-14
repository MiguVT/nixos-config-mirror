{ pkgs, ... }:

{
  home-manager.users.miguvt = {
    programs.chromium.enable = {
      enabe = true;
      package = pkgs.ungoogled-chromium;
    };
  };
}
