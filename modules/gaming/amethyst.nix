{ pkgs, ... }:

let
  appImage = pkgs.fetchurl {
    url = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/releases/download/v2.4.2/AmethystModManager-2.4.2-x86_64.AppImage";
    sha256 = "acca19a3e6ad19fd50be087ddce379140af91e97153ff076de7d4424fdce7876";
  };

  amethyst = pkgs.appimageTools.wrapAppImage {
    name = "amethyst-mod-manager";
    src = appImage;
  };

  desktop = pkgs.writeTextFile {
    name = "amethyst-mod-manager.desktop";
    destination = "/share/applications/AmethystModManager.desktop";
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Amethyst Mod Manager
      Comment=Mod manager for Amethyst
      Exec=${amethyst}/bin/AmethystModManager
      Terminal=false
      Categories=Game;
    '';
  };

  final = pkgs.symlinkJoin {
    name = "amethyst-mod-manager";
    paths = [ amethyst desktop ];
  };
in
{
  home-manager.users.miguvt.home.packages = [ final ];
}
