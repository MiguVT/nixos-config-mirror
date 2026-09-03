{ pkgs, ... }:

{
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };

  home-manager.users.miguvt = { pkgs, ... }: {
    programs.fish.functions."no-rgb" = {
      description = "Turn off all OpenRGB devices";
      body = "openrgb --mode static --color 000000";
    };
  };
}
