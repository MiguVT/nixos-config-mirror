{ pkgs, ... }:

{
  # System-wide shared-library injection (LD_LIBRARY_PATH) for apps that need
  # FHS-style libraries: games, Unity editors (ALCOM), etc. Applied to all
  # sessions via PAM.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Core runtime
      stdenv.cc.cc.lib
      glibc
      zlib
      openssl
      icu
      util-linux
      glib
      # libxml2_13: classic libxml2.so.2 SONAME (2.15.x bumped it to .so.16)
      libxml2_13
      nss

      # Graphics (Unity Editor: OpenGL + Vulkan)
      libglvnd
      vulkan-loader
      libdrm
      libgbm

      # Audio (Unity Editor + VRChat)
      alsa-lib
      libpulseaudio

      # GUI (Unity Editor: GTK3)
      gtk3

      # X11
      libx11
      libxcursor
      libxrandr
      libxi
      libxext
      libxfixes
      libxcomposite
      libxkbcommon

      # Fonts / text
      fontconfig
      freetype
      harfbuzz

      # Media
      libogg
      libvorbis

      # Image loading (Unity Editor)
      gdk-pixbuf
    ];
  };
}
