{ pkgs, ... }:

{
  services.xserver.enable = true; # Xwayland compatibility
  services.desktopManager.plasma6.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    inter
  ];

  fonts.fontconfig = {
    antialias = true;
    subpixel = {
      rgba = "rgb";
      lcdfilter = "default";
    };
    hinting = {
      enable = true;
      style = "slight";
    };
  };

  environment.systemPackages = with pkgs; [
    plasma-panel-colorizer
    kdePackages.krohnkite
    klassy
    kdePackages.qtstyleplugin-kvantum
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Copy (not symlink) the user's KWin layout into sddm's config dir at boot so
  # the greeter matches the session; a symlink is unreadable since /home/miguvt is 0700.
  systemd.tmpfiles.rules = [
    "d /var/lib/sddm/.config 0750 sddm sddm -"
    "R! /var/lib/sddm/.config/kwinoutputconfig.json"
    "C /var/lib/sddm/.config/kwinoutputconfig.json 0644 sddm sddm - /home/miguvt/.config/kwinoutputconfig.json"
  ];
}
