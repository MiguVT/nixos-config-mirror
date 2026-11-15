{ pkgs, ... }:

let
  pname = "vrcnext";
  version = "2027.2.0";
  src = pkgs.fetchurl {
    url = "https://github.com/shinyflvre/VRCNext/releases/download/v${version}/Linux-VRCNext-${version}-x86_64.AppImage";
    hash = "sha256-8MXu5GKlgMAL2UCP1MH8ov0NV1hAMrAAnRb0rZQGTLs=";
  };
  # Unpacked AppImage, used to pull out the desktop entry and icons.
  contents = pkgs.appimageTools.extract { inherit pname version src; };
  vrcnext = pkgs.appimageTools.wrapType2 {
    inherit pname version src;
    extraPkgs = pkgs: with pkgs; [
      gtk3
      glib
      webkitgtk_4_1
      libcanberra-gtk3
      zenity
      icu
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-libav
    ];
    # Desktop entry and icon come from the AppImage itself; only the Exec
    # needs patching, since the wrapper binary is lowercase "vrcnext".
    extraInstallCommands = ''
      install -Dm644 ${contents}/vrcnext.desktop $out/share/applications/vrcnext.desktop
      substituteInPlace $out/share/applications/vrcnext.desktop \
        --replace-fail 'Exec=VRCNext %u' 'Exec=vrcnext %u'
      cp -r ${contents}/usr/share/icons $out/share
    '';
  };
in
{
  # VRCNext (VRChat companion overlay app). Not packaged in nixpkgs;
  # wraps the upstream AppImage in an FHS environment. The extra packages
  # mirror the system dependencies the upstream install script expects
  # (WebKitGTK 4.1, GTK, zenity, ICU, GStreamer).
  home-manager.users.miguvt.home.packages = [ vrcnext ];
}
