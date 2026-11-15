{ pkgs, ... }:

{
  home-manager.users.miguvt.home.packages = [
    # VRCNext (VRChat companion overlay app). Not packaged in nixpkgs;
    # wraps the upstream AppImage in an FHS environment. The extra packages
    # mirror the system dependencies the upstream install script expects
    # (WebKitGTK 4.1, GTK, zenity, GStreamer).
    (pkgs.appimageTools.wrapType2 {
      pname = "vrcnext";
      version = "2027.2.0";
      src = pkgs.fetchurl {
        url = "https://github.com/shinyflvre/VRCNext/releases/download/v2027.2.0/Linux-VRCNext-2027.2.0-x86_64.AppImage";
        hash = "sha256-8MXu5GKlgMAL2UCP1MH8ov0NV1hAMrAAnRb0rZQGTLs=";
      };
      extraPkgs = pkgs: with pkgs; [
        gtk3
        glib
        webkitgtk_4_1
        libcanberra-gtk3
        zenity
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-libav
      ];
    })
  ];
}
