{ pkgs, ... }:

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
