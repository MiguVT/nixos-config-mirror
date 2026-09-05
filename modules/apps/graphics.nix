{ pkgs, ... }:

let
  photogimp = pkgs.fetchFromGitHub {
    owner = "Diolinux";
    repo = "PhotoGIMP";
    rev = "b3c639de87120e98b7d224ee4c9e116464cf0292";
    sha256 = "c9dfeafe18b232a9d9ca6f78f1974aa521754e495a2d67e236dbbe661b555c85";
  };
in
{
  home-manager.users.miguvt = {
    home.packages = with pkgs; [
      gimp-with-plugins
    ];

    # PhotoGIMP: Photoshop-like layout for GIMP 3.x
    home.file = {
      ".config/GIMP/3.0".source = "${photogimp}/.config/GIMP/3.0";
      ".local/share/applications/org.gimp.GIMP.desktop".source = "${photogimp}/.local/share/applications/org.gimp.GIMP.desktop";
      ".local/share/icons/hicolor".source = "${photogimp}/.local/share/icons/hicolor";
    };
  };
}
