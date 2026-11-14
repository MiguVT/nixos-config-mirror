{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Pin zen2: 7.3.4-zen1 in nixos-unstable panics at boot on a NULL BH worker
  # pointer; fixed upstream in 7.3.4-zen2, not yet merged to nixos-unstable.
  # Remove this overlay once nixpkgs#586820 lands in nixos-unstable.
  linux_zen_custom = pkgs.linux_zen.override {
    argsOverride = {
      version = "7.3.4";
      modDirVersion = "7.3.4-zen2";
      src = pkgs.fetchFromGitHub {
        owner = "zen-kernel";
        repo = "zen-kernel";
        rev = "v7.3.4-zen2";
        hash = "sha256-k1tbY69qU0RRlX5xY+GwH548meeIQ9r3HBnX1ByFT+w=";
      };
    };
  };
in
{
  boot.kernelPackages = pkgs.linuxPackagesFor linux_zen_custom;

  # AMD P-State active mode for Zen 3 CPPC power scaling
  boot.kernelParams = [ "amd_pstate=active" ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.fstrim.enable = true;
}
