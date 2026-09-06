{ pkgs, ... }:

let
  appImage = pkgs.fetchurl {
    url = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/releases/download/v2.4.1/AmethystModManager-2.4.1-x86_64.AppImage";
    sha256 = "9f235e028c3f89081f55d31d6fac29932ef79b9514b344a86f850459aef6a05c";
  };

  # The AppImage needs the Steam/FHS runtime, so the wrapper always launches it
  # through steam-run (same for CLI and the desktop entry below).
  wrapper = pkgs.writeTextFile {
    name = "amethyst-mod-manager";
    destination = "/bin/AmethystModManager";
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      steam_run="$(command -v steam-run || true)"
      if [ -z "$steam_run" ]; then
        echo "error: steam-run not found in PATH" >&2
        exit 1
      fi

      exec "$steam_run" "${appImage}" "$@"
    '';
  };

  desktop = pkgs.writeTextFile {
    name = "amethyst-mod-manager.desktop";
    destination = "/share/applications/AmethystModManager.desktop";
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Amethyst Mod Manager
      Comment=Mod manager for Amethyst
      Exec=${wrapper}/bin/AmethystModManager
      Terminal=false
      Categories=Game;
    '';
  };

  amethyst = pkgs.symlinkJoin {
    name = "amethyst-mod-manager";
    paths = [ wrapper desktop ];
  };
in
{
  users.users.miguvt.packages = [ amethyst ];
}
