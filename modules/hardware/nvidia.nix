{ config, pkgs, ... }:

{
  # Set system-wide environment variables
  environment.sessionVariables = {
    # Expands global NVIDIA shader cache size to 100GB (100 * 1024 * 1024 * 1024 bytes)
    __GL_SHADER_DISK_CACHE_SIZE = "107374182400";
  };

  hardware.graphics = {
    enable = true;
    # Required for 32-bit Steam games
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # Hide VRR/G-Sync capabilities from user space. Without this, wired VR
  # headsets tear when a VRR-capable monitor is attached, even with VRR
  # disabled in the compositor and the monitor's OSD.
  boot.kernelParams = [ "nvidia-modeset.conceal_vrr_caps=1" ];

  # GPU tuning daemon: power limit, fan curves and a V/F curve overclock,
  # none of which are reachable through nvidia-settings without Coolbits+X.
  # The Default/Gaming/VR profiles live in /etc/lact/config.yaml and stay
  # daemon-owned on purpose: pinning them via services.lact.settings turns
  # that file into a read-only symlink and breaks GUI edits and profile
  # auto-switching.
  services.lact.enable = true;

  # LACT switches profiles on gamemode/SteamVR start by querying the *user*
  # session bus (`sudo -u <user> busctl --user ...`). The systemd unit's PATH
  # only contains coreutils/findutils/grep/sed/systemd, so without sudo on the
  # path the profile watcher logs "could not list gamemode games" and the
  # Gaming/VR profiles never activate.
  systemd.services.lactd.path = [ pkgs.sudo ];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = false;

    # Open-source kernel module (stable on Ampere)
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
