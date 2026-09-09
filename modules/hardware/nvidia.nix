{ config, ... }:

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
