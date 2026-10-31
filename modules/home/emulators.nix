{ pkgs, ... }:

{
  home.packages = [
    pkgs.ares
    pkgs.azahar
    pkgs.cemu
    pkgs.dolphin-emu
    pkgs.eden
    pkgs.flycast
    pkgs.melonds
    pkgs.pcsx2
    pkgs.ppsspp
    pkgs.rpcs3
    pkgs.ryubing
    pkgs.shadps4
    pkgs.shadps4-qtlauncher
    pkgs.vita3k
    pkgs.xemu
    pkgs.xenia-canary
  ];
}
