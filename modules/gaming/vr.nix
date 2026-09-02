{ pkgs, ... }:

{
  services.monado = {
    enable = true;
    defaultRuntime = true;
  };

  systemd.user.services.monado.environment = {
    # Use SteamVR's Lighthouse tracking for the base stations
    STEAMVR_LH_ENABLE = "1";

    # NVIDIA: fix compositor work not being scheduled on time (head-motion latency)
    XRT_COMPOSITOR_USE_PRESENT_WAIT = "1";
    U_PACING_COMP_TIME_FRACTION_PERCENT = "90";
  };

  users.users.miguvt.packages = [
    # OpenVR -> OpenXR compatibility layer (SteamVR replacement for OpenVR apps)
    pkgs.xrizer
    pkgs.wayvr
  ];
}
