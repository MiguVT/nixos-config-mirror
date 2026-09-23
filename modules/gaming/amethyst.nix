{ pkgs, ... }:

let
  appImage = pkgs.fetchurl {
    url = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/releases/download/v2.4.2/AmethystModManager-2.4.2-x86_64.AppImage";
    sha256 = "acca19a3e6ad19fd50be087ddce379140af91e97153ff076de7d4424fdce7876";
  };

  # fetchurl yields a read-only (0444) file; install an executable copy.
  appImageExec = pkgs.runCommand "amethyst-mod-manager-appimage" { } ''
    install -Dm755 ${appImage} $out/AmethystModManager.AppImage
  '';

  # The AppImage needs the Steam/FHS runtime, so the wrapper always launches it
  # through steam-run (same for CLI and the desktop entry below).
  wrapper = pkgs.writeShellScriptBin "AmethystModManager" ''
    set -euo pipefail

    steam_run="$(command -v steam-run || true)"
    if [ -z "$steam_run" ]; then
      echo "error: steam-run not found in PATH" >&2
      exit 1
    fi

    exec "$steam_run" "${appImageExec}/AmethystModManager.AppImage" "$@"
  '';

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
    paths = [ wrapper desktop appImageExec ];
  };
in
{
  home-manager.users.miguvt.home.packages = [ amethyst ];
}
