{ pkgs, ... }:

{
  hardware.i2c.enable = true;

  boot.kernelModules = [
    "i2c-dev"
    # Super I/O: motherboard RGB lives behind SMBus (NCT679x)
    "nct6775"
    "i2c-piix4"
  ];

  users.users.miguvt.extraGroups = [ "i2c" ];

  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb;
  };
}
