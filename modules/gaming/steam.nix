{ inputs, pkgs, ... }:

let
  # Output geometry shared by the nested launcher and the Steam Deck session.
  width = 1920;
  height = 1080;
  refresh = 165;

  steamosScript = pkgs.writeShellScriptBin "steamos-gamescope" ''
    # Gracefully shut down Steam and wait up to 8 seconds before force-killing
    if pgrep -x steam > /dev/null 2>&1; then
      steam -shutdown 2>/dev/null || true
      for i in {1..16}; do
        if ! pgrep -x steam > /dev/null 2>&1; then
          break
        fi
        sleep 0.5
      done
      pkill -9 -x steam 2>/dev/null || true
    fi

    # Launch Steam Gamepad UI inside a nested Gamescope session
    exec gamescope \
      --rt \
      --backend wayland \
      --force-grab-cursor \
      -e \
      -f \
      -w ${toString width} -h ${toString height} \
      -W ${toString width} -H ${toString height} \
      -r ${toString refresh} \
      -- steam -gamepadui
  '';
in
{
  # SteamOS (Gamescope) launcher for vicinae/KDE app menu
  home-manager.users.miguvt.xdg.desktopEntries = {
    steamos-gamescope = {
      name = "SteamOS (Gamescope)";
      comment = "Launch Steam Deck Gamepad UI inside Gamescope";
      exec = "${steamosScript}/bin/steamos-gamescope";
      icon = "steam";
      categories = [ "Game" ];
    };
    steam-gamepadui = {
      name = "Steam (Gamepad UI)";
      comment = "Launch Steam Big Picture / Deck UI natively on KDE";
      exec = "steam -gamepadui";
      icon = "steam";
      categories = [ "Game" ];
    };
  };

  # Fixed compatibility-tools entry for non-Steam launchers (e.g. BSManager),
  # which need a Proton directory containing `proton`. Points at the Nix build
  # so the path stays valid across GE-Proton updates and GC.
  home-manager.users.miguvt.home.file = {
    ".local/share/Steam/compatibilitytools.d/GE-Proton-nix".source =
      pkgs.proton-ge-bin.steamcompattool;
  };

  programs.steam = {
    enable = true;
    package = pkgs.millennium-steam.override {
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

    # Official Steam Deck session option (independent of nested launcher).
    # Enables the "Steam Deck" login session from SDDM.
    gamescopeSession = {
      enable = true;
      args = [
        "-w"
        (toString width)
        "-h"
        (toString height)
        "-W"
        (toString width)
        "-H"
        (toString height)
        "-r"
        (toString refresh)
        "--adaptive-sync"
      ];
    };
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

  # WINE/Proton need far more open files than the systemd default.
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "1048576";
    }
    {
      domain = "*";
      type = "hard";
      item = "nofile";
      value = "1048576";
    }
  ];

  # Modern NixOS structured systemd settings
  systemd.settings.Manager.DefaultLimitNOFILE = "1048576";
  systemd.user.settings.Manager.DefaultLimitNOFILE = "1048576";

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
