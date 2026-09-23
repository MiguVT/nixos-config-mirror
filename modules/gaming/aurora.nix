{ pkgs, ... }:

let
  appImage = pkgs.fetchurl {
    url = "https://github.com/Daturaxoxo/Aurora/releases/download/v2.2.2/Aurora-x86_64.AppImage";
    sha256 = "1575afef62730a93cd432f6c2886186da535bf70a7b016f98f84657403b9b4e9";
  };

  # fetchurl yields a read-only (0444) file; install an executable copy.
  appImageExec = pkgs.runCommand "aurora-appimage" { } ''
    install -Dm755 ${appImage} $out/Aurora.AppImage
  '';

  # The AppImage needs the Steam/FHS runtime, so the wrapper always launches it
  # through steam-run (same for CLI and the desktop entry below).
  wrapper = pkgs.writeShellScriptBin "Aurora" ''
    set -euo pipefail

    steam_run="$(command -v steam-run || true)"
    if [ -z "$steam_run" ]; then
      echo "error: steam-run not found in PATH" >&2
      exit 1
    fi

    exec "$steam_run" "${appImageExec}/Aurora.AppImage" "$@"
  '';

  desktop = pkgs.writeTextFile {
    name = "aurora.desktop";
    destination = "/share/applications/Aurora.desktop";
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Aurora
      Comment=Lightweight mod manager and mod platform
      Exec=${wrapper}/bin/Aurora
      Terminal=false
      Categories=Game;
    '';
  };

  aurora = pkgs.symlinkJoin {
    name = "aurora-mod-manager";
    paths = [ wrapper desktop appImageExec ];
  };
in
{
  users.users.miguvt.packages = [ aurora ];
}
