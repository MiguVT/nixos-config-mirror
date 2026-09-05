{ pkgs, ... }:

let
  photogimp = pkgs.fetchFromGitHub {
    owner = "Diolinux";
    repo = "PhotoGIMP";
    rev = "b3c639de87120e98b7d224ee4c9e116464cf0292";
    sha256 = "a0a22aeda3ef959c70a9d895eb76938e4c65358e083245f350f6e0f22b127831";
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
