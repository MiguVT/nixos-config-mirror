{ pkgs, ... }:

let
  appImage = pkgs.fetchurl {
    url = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/releases/download/v2.4.1/AmethystModManager-2.4.1-x86_64.AppImage";
    sha256 = "9f235e028c3f89081f55d31d6fac29932ef79b9514b344a86f850459aef6a05c";
  };

  amethyst = pkgs.runCommand "amethyst-mod-manager" { } ''
    install -Dm755 ${appImage} $out/bin/AmethystModManager
  '';
in
{
  users.users.miguvt.packages = [ amethyst ];
}
