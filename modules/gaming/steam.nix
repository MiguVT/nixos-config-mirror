{ inputs, pkgs, ... }:

let
  steamosScript = pkgs.writeShellScriptBin "steamos-gamescope" ''
    # Close any running Steam instance so Gamescope can take over.
    # Use exact name matching (-x) so we don't kill ourselves (steamos-gamescope contains "steam").
    if pgrep -x steam > /dev/null 2>&1; then
      steam -shutdown 2>/dev/null || true
      sleep 2
      pkill -x steam 2>/dev/null || true
    fi
    # Launch Steam Gamepad UI inside a nested Gamescope session
    # -e: exit Gamescope when the child exits
    # -f: run in fullscreen mode (auto-detects main display resolution and refresh rate)
    # --: separator between gamescope and steam args
    exec gamescope -e -f -- steam -gamepadui
  '';
in
{

  programs.steam = {
    enable = true;
    package = inputs.millennium.packages.${pkgs.stdenv.hostPlatform.system}.millennium-steam.override {
      extraProfile = ''
        # Allows Monado/WiVRn to be used
        export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
        # Fixes timezones on VRChat if used
        unset TZ
      '';
    };

    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;

    extraCompatPackages = [
      pkgs.proton-ge-bin
      pkgs.dwproton-bin
    ];

    protontricks.enable = true;
  };

  # Proton/WINE prefix manager for Steam games (Flatpak from Flathub).
  services.flatpak.packages = [ "ru.linux_gaming.PortProton" ];

  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # Proton runner for non-Steam games; `umu-run` is available system-wide.
  environment.systemPackages = [
    pkgs.umu-launcher
    steamosScript
  ];

  # WINE/Proton need far more open files than the systemd default. The
  # limits.d file covers PAM logins; DefaultLimitNOFILE covers systemd user
  # sessions, where PAM cannot raise the hard limit above the manager's cap.
  environment.etc."security/limits.d/99-wine-proton.conf".text = ''
    * soft nofile 1048576
    * hard nofile 1048576
  '';

  environment.etc."systemd/system.conf.d/wine-proton.conf".text = ''
    [Manager]
    DefaultLimitNOFILE=1048576
  '';

  # Create the SteamOS (Gamescope) .desktop entry
  environment.etc."applications/steamos-gamescope.desktop".text = ''
    [Desktop Entry]
    Name=SteamOS (Gamescope)
    Comment=Launch Steam Deck Gamepad UI inside Gamescope
    Exec=${steamosScript}
    Icon=steam
    Type=Application
    Categories=Game
  '';

  # SRMP spams its Logs dir without ever clearing/rotating. Overlay it with a
  # small tmpfs so the endless debug/error logs never hit disk or accumulate.
  fileSystems."/mnt/data/Games/Steam/steamapps/common/Slime Rancher/SRMP/Logs" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [
      "size=10M"
      "uid=1000"
      "gid=100"
      "mode=0755"
    ];
  };
}
