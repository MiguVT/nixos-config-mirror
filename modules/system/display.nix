{ pkgs, ... }:

{
  services.xserver.enable = true; # Xwayland compatibility
  services.desktopManager.plasma6.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    inter
    # Microsoft fonts (Verdana, Arial, Calibri, ...) for Unity editors / ALCOM
    corefonts
    vista-fonts
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

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    merkuro
    kontact
    kmail
    akonadiconsole
    
    # Games
    kpat
    kmahjongg
    kmines
    ksudoku
    
    # Educational
    kanagram
    kgeography
    khangman
    kiten
    ktouch
    kturtle
    kwordquiz
    
    # Productivity/Utilities they don't want
    akregator
    dragon
    kolourpaint
    konversation
    konsole
    kcalc
    kompare
    
    # Accessibility
    kmag
    kmousetool
    kmouth
    
    # Development (except kate which they want to keep)
    kdevelop
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
