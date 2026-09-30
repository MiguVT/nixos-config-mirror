{ pkgs, ... }:

{
  # System-wide shared-library injection (LD_LIBRARY_PATH) for apps that need
  # FHS-style libraries: games, Unity editors (ALCOM), etc. Applied to all
  # sessions via PAM.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      glibc
      openssl
      icu
      util-linux
      libglvnd
      libx11
      libxcursor
      libxrandr
      libxi
    ];
  };
}
