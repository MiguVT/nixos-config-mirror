{ pkgs, lib, ... }:

let
  photoGimp = (pkgs.fetchzip {
    url = "https://github.com/Diolinux/PhotoGIMP/releases/download/3.1/PhotoGIMP-linux.zip";
    # hash of the unpacked tree (fetchzip uses recursiveHash), not the zip
    sha256 = "6b236130b8d28d84497340c3ffca2a29dd213861cb518068adae3ec6d562fe24";
  }) + "/PhotoGIMP-linux";

  iconSizes = [ "16x16" "32x32" "48x48" "64x64" "128x128" "512x512" ];

  iconFiles = lib.mapAttrs' (size: _: {
    name = "icons/hicolor/${size}/apps/photogimp.png";
    value.source = "${photoGimp}/.local/share/icons/hicolor/${size}/apps/photogimp.png";
  }) (lib.genAttrs iconSizes (_: true));
in

{
  home-manager.users.miguvt = {
    home.packages = with pkgs; [
      gimp-with-plugins
    ];

    # PhotoGIMP 3.1 theme profile (Diolinux/PhotoGIMP)
    xdg.configFile."GIMP/3.0".source = "${photoGimp}/.config/GIMP/3.0";

    xdg.dataFile =
      iconFiles
      // {
        "applications/org.gimp.GIMP.desktop".source =
          "${photoGimp}/.local/share/applications/org.gimp.GIMP.desktop";
        "icons/hicolor/photogimp.png".source =
          "${photoGimp}/.local/share/icons/hicolor/photogimp.png";
      };
  };
}
