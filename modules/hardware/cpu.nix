{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # AMD P-State active mode for Zen 3 CPPC power scaling
  boot.kernelParams = [ "amd_pstate=active" ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.fstrim.enable = true;
}
