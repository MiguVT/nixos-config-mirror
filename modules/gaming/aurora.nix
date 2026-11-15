{ pkgs, ... }:

let
  pname = "aurora";
  version = "2.3.2";
  src = pkgs.fetchurl {
    url = "https://github.com/Daturaxoxo/Aurora/releases/download/v${version}/Aurora-x86_64.AppImage";
    hash = "sha256-nHCesdTnNirwLx+XdyMhbgeb6LCuFRnDg2hdTQQYCVI=";
  };
  # Unpacked AppImage, used to pull out the desktop entry and icons.
  contents = pkgs.appimageTools.extract { inherit pname version src; };
  aurora = pkgs.appimageTools.wrapType2 {
    inherit pname version src;
    # The bundled launcher binary only misses fontconfig and libxcb at
    # runtime; the rest of its libraries are inside the AppImage.
    extraPkgs = pkgs: with pkgs; [
      fontconfig
      libxcb
      libxcb-wm
      libxcb-image
      libxcb-keysyms
      libxcb-render-util
    ];
    # Desktop entry and icon come from the AppImage itself; only the Exec
    # needs patching, since the wrapper binary is lowercase "aurora".
    extraInstallCommands = ''
      install -Dm644 ${contents}/aurora.desktop $out/share/applications/aurora.desktop
      substituteInPlace $out/share/applications/aurora.desktop \
        --replace-fail 'Exec=Aurora %u' 'Exec=aurora %u'
      cp -r ${contents}/usr/share/icons $out/share
    '';
  };
in
{
  # Aurora (mod manager and launcher, github.com/Daturaxoxo/Aurora). Not
  # packaged in nixpkgs; wraps the official AppImage in an FHS environment.
  home-manager.users.miguvt.home.packages = [ aurora ];
}
