{ pkgs, ... }:

{
  home-manager.users.miguvt.home.packages = [
    # VRCX-0 (fork of VRCX). Not packaged in nixpkgs; wraps the official
    # Tauri AppImage in an FHS environment. It bundles most libraries, but
    # the WebKit/GStreamer stack is provided too since Tauri apps commonly
    # need the host's copy for media playback.
    (pkgs.appimageTools.wrapType2 {
      pname = "vrcx-0";
      version = "2.34.0";
      src = pkgs.fetchurl {
        url = "https://github.com/Map1en/VRCX-0/releases/download/v2.34.0/VRCX-0_2.34.0_linux_x86_64.AppImage";
        hash = "sha256-JiVGuIlRFeddMM0FHo9Ope5XbaXGqtEgG+ce2ctmE7s=";
      };
      extraPkgs = pkgs: with pkgs; [
        gtk3
        glib
        webkitgtk_4_1
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
      ];
    })
  ];
}
