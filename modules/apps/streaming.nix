{ lib, pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;

    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };

    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
      obs-backgroundremoval
      obs-vkcapture
      obs-gstreamer
    ];
  };

  # Headless Stream Deck server (web UI on :8088)
  systemd.user.services.bitfocus-companion = {
    description = "Bitfocus Companion Stream Deck server";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = lib.getExe pkgs.bitfocus-companion;
      Restart = "on-failure";
    };
  };

  environment.systemPackages = with pkgs; [
    v4l-utils
    ffmpeg
  ];

  # Grant the logged-in desktop user access to Bitfocus Stream Deck (USB + HID)
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0fd9", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="0fd9", TAG+="uaccess"
  '';
}
