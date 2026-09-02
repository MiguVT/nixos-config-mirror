{ pkgs, ... }:

{
  # Monado is the default OpenXR runtime (unstable build provided by nixpkgs-xr)
  services.monado = {
    enable = true;
    defaultRuntime = true;
  };

  # Runtime environment for the Monado user service
  systemd.user.services.monado.environment = {
    # Valve Index: drive the base stations through the SteamVR Lighthouse driver
    STEAMVR_LH_ENABLE = "1";

    # NVIDIA: compositor work is not scheduled on time without these
    XRT_COMPOSITOR_USE_PRESENT_WAIT = "1";
    U_PACING_COMP_TIME_FRACTION_PERCENT = "90";
  };

  users.users.miguvt.packages = [
    # OpenVR -> OpenXR shim so OpenVR apps run on Monado without SteamVR
    pkgs.xrizer
    # Overlay: see and launch the desktop from inside VR
    pkgs.wayvr
    # Room-boundary overlay for OpenXR; wraps the lovr engine, so keep both in the closure
    pkgs.lovr-playspace
    pkgs.lovr
  ];

  # TODO: re-enable once proton-rtsp-bin is fixed for the new proton-ge-bin overrideAttrs interface
  # programs.steam.extraCompatPackages = [ pkgs.proton-rtsp-bin ];
}
