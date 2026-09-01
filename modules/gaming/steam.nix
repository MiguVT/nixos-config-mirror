{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    package = pkgs.millennium-steam;

    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;

    extraCompatPackages = [
      pkgs.proton-ge-bin
      pkgs.dwproton-bin
    ];
  };

  programs.gamemode.enable = true;
}
