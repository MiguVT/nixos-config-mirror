{ lib, pkgs, ... }:

{
  # Monado is the default OpenXR runtime (unstable build provided by nixpkgs-xr)
  services.monado = {
    enable = true;
    defaultRuntime = true;
  };

  # Don't socket-activate Monado: apps (e.g. Steam probing the VR runtime)
  # connecting to the IPC socket would otherwise auto-start it. Start it
  # manually with `systemctl --user start monado`.
  systemd.user.sockets.monado.wantedBy = lib.mkForce [ ];
  systemd.user.services.monado.wantedBy = lib.mkForce [ ];

  # Runtime environment for the Monado user service
  systemd.user.services.monado.environment = {
    # Valve Index: drive the base stations through the SteamVR Lighthouse driver
    STEAMVR_LH_ENABLE = "1";

    # NVIDIA: compositor work is not scheduled on time without these
    XRT_COMPOSITOR_USE_PRESENT_WAIT = "1";

    # Lease the Index connector from KWin for low-latency direct mode instead
    # of presenting through a composited Wayland window
    XRT_COMPOSITOR_FORCE_WAYLAND_DIRECT = "1";

    # Use the graphics-shader layer pipeline instead of the compute squasher.
    # The compute path corrupts colors (dark/patchy rectangles) when WayVR
    # runs alongside a game on NVIDIA; confirmed fixed with the graphics
    # path on RTX 3090. WayVR-specific (lovr-playspace overlay is clean),
    # and not caused by WayVR's skybox layer (corrupts with skybox off).
    XRT_COMPOSITOR_COMPUTE = "0";
    U_PACING_COMP_TIME_FRACTION_PERCENT = "90";

    # Floor on compositor pacing time to reduce headset-view stuttering
    U_PACING_COMP_MIN_TIME_MS = "5";
  };

  # A negative nice value needs CAP_SYS_NICE, which a user session lacks by
  # default, so systemd --user silently drops Nice=. Grant it to the user
  # manager (this applies to all user managers; miguvt is currently the only
  # normal user), then set it:
  systemd.services."user@".serviceConfig.AmbientCapabilities = [ "CAP_SYS_NICE" ];
  systemd.user.services.monado.serviceConfig.Nice = -20;

  home-manager.users.miguvt.home.packages = [
    # OpenVR -> OpenXR shim so OpenVR apps run on Monado without SteamVR
    pkgs.xrizer
    # Overlay: see and launch the desktop from inside VR
    pkgs.wayvr
    # Room-boundary overlay for OpenXR; wraps the lovr engine, so keep both in the closure
    pkgs.lovr-playspace
    pkgs.lovr
    # Power base stations on/off over Bluetooth
    pkgs.lighthouse-steamvr
  ];

  # VR/RTSP compat tool for Steam (list-appends with steam.nix's extraCompatPackages)
  programs.steam.extraCompatPackages = [ pkgs.proton-rtsp-bin ];
}
