{ pkgs, ... }:

{
  boot.kernelModules = [
    "i2c-dev"
    # Super I/O: motherboard RGB lives behind SMBus (NCT679x)
    "nct6775"
  ];

  users.groups.i2c = {
    gid = 1010;
    members = [ "miguvt" ];
  };

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
