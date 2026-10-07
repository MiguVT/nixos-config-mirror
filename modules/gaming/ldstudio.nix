{ pkgs, ... }:

let
  appImage = pkgs.fetchurl {
    url = "https://files.lodemc.net/app/linux/1.1.0/ldstudio-1.1.0-alpha.AppImage";
    sha256 = "5bff6d59421a35262a6b7d7a0a134a760d99e5a3a42a29f8f997e82935a00ee5";
  };

  ldstudio = pkgs.appimageTools.wrapAppImage {
    name = "ldstudio";
    src = appImage;
  };

  desktop = pkgs.writeTextFile {
    name = "ldstudio.desktop";
    destination = "/share/applications/ldstudio.desktop";
    text = ''
      [Desktop Entry]
      Type=Application
      Name=Lode Studio
      Comment=The IDE for Minecraft Server Developers
      Exec=${ldstudio}/bin/ldstudio --no-sandbox
      Terminal=false
      Categories=Development;
    '';
  };

  final = pkgs.symlinkJoin {
    name = "ldstudio";
    paths = [ ldstudio desktop ];
  };
in
{
  home-manager.users.miguvt.home.packages = [ final ];
}
