{ pkgs, ... }:

let
  pname = "vrcx-0";
  version = "2.34.0";
  src = pkgs.fetchurl {
    url = "https://github.com/Map1en/VRCX-0/releases/download/v${version}/VRCX-0_${version}_linux_x86_64.AppImage";
    hash = "sha256-JiVGuIlRFeddMM0FHo9Ope5XbaXGqtEgG+ce2ctmE7s=";
  };
  # Unpacked AppImage, used to pull out the desktop entry and icons.
  contents = pkgs.appimageTools.extract { inherit pname version src; };
  vrcx0 = pkgs.appimageTools.wrapType2 {
    inherit pname version src;
    extraPkgs = pkgs: with pkgs; [
      gtk3
      glib
      webkitgtk_4_1
      libgcrypt
      libgpg-error
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
    ];
    # Desktop entry and icon come from the AppImage itself. The upstream
    # entry ships an empty Categories and Exec pointing at the AppRun
    # convention, so both are patched to fit the wrapped package.
    extraInstallCommands = ''
      install -Dm644 ${contents}/VRCX-0.desktop $out/share/applications/vrcx-0.desktop
      substituteInPlace $out/share/applications/vrcx-0.desktop \
        --replace-fail 'Exec=vrcx-0' 'Exec=vrcx-0 %u' \
        --replace-fail 'Categories=' 'Categories=Utility;Network;'
      cp -r ${contents}/usr/share/icons $out/share
    '';
  };
in
{
  # VRCX-0 (fork of VRCX). Not packaged in nixpkgs; wraps the official
  # Tauri AppImage in an FHS environment. It bundles most libraries, but
  # the WebKit/GStreamer stack is provided too since Tauri apps commonly
  # need the host's copy for media playback.
  home-manager.users.miguvt.home.packages = [ vrcx0 ];
}
