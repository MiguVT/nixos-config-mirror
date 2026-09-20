{ inputs, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    package = inputs.millennium.packages.${pkgs.stdenv.hostPlatform.system}.millennium-steam.override {
      extraProfile = ''
        # Allows Monado/WiVRn to be used
        export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
        # Fixes timezones on VRChat if used
        unset TZ
      '';
    };

    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;

    extraCompatPackages = [
      pkgs.proton-ge-bin
      pkgs.dwproton-bin
    ];

    protontricks.enable = true;
  };

  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  # WINE/Proton need far more open files than the systemd default. The
  # limits.d file covers PAM logins; DefaultLimitNOFILE covers systemd user
  # sessions, where PAM cannot raise the hard limit above the manager's cap.
  environment.etc."security/limits.d/99-wine-proton.conf".text = ''
    * soft nofile 1048576
    * hard nofile 1048576
  '';

  environment.etc."systemd/system.conf.d/wine-proton.conf".text = ''
    [Manager]
    DefaultLimitNOFILE=1048576
  '';

  # SRMP spams its Logs dir without ever clearing/rotating. Overlay it with a
  # small tmpfs so the endless debug/error logs never hit disk or accumulate.
  fileSystems."/mnt/data/Games/Steam/steamapps/common/Slime Rancher/SRMP/Logs" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [
      "size=10M"
      "uid=1000"
      "gid=100"
      "mode=0755"
    ];
  };
}
