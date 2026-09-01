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

  # Symlinks user's KWin layout to SDDM for consistent login screen display config
  systemd.tmpfiles.rules = [
    "L+ /var/lib/sddm/.config/kwinoutputconfig.json - sddm sddm - /home/miguvt/.config/kwinoutputconfig.json"
  ];
}
