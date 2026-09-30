{ pkgs, ... }:

{
  # ALCOM (free, MIT) manages VRChat Unity projects; Unity Hub (unfree) installs
  # the editors ALCOM launches. Unity Hub is allowlisted in configuration.nix.
  # Unity editors get their shared libraries from the system-wide nix-ld
  # (modules/system/nix-ld.nix).
  home-manager.users.miguvt.home.packages = with pkgs; [
    alcom
    unityhub
    # ALCOM loads GStreamer at runtime (not a build dep) for its live
    # screen-capture preview; the appsink element ships in gst-plugins-base.
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
  ];
}
