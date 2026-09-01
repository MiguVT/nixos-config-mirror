{ pkgs, ... }:

let
  resetValveIndex = pkgs.writeShellScript "reset-valve-index" ''
    set -eu

    device="$1"
    stateDir="/run/valve-index-reset"
    flag="$stateDir/done"
    lock="$stateDir/lock"

    case "$device" in
      hidraw*) ;;
      *) exit 1 ;;
    esac

    sleep 2

    exec 9>"$lock"
    ${pkgs.util-linux}/bin/flock 9

    if [ -e "$flag" ]; then
      exit 0
    fi

    # Payload: 0x16 0x01 followed by 62 zero bytes (matches known-good Arch udev rule)
    if ! printf '\x16\x01' \
      | ${pkgs.coreutils}/bin/cat - /dev/zero \
      | ${pkgs.coreutils}/bin/head -c 64 \
      > "/dev/$device"
    then
      exit 1
    fi

    ${pkgs.coreutils}/bin/touch "$flag"
  '';
in
{
  systemd.tmpfiles.settings."valve-index-reset" = {
    "/run/valve-index-reset".d = {
      mode = "0755";
      user = "root";
      group = "root";
    };
  };

  systemd.services."valve-index-reset@" = {
    description = "Reset Valve Index HID interface";

    # Do not bind to device lifetime since the reset causes re-enumeration
    after = [ "dev-%i.device" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${resetValveIndex} %i";
      TimeoutStartSec = "15s";

      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "strict";
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictSUIDSGID = true;
      LockPersonality = true;

      ReadWritePaths = [
        "/run/valve-index-reset"
      ];
    };
  };

  services.udev.extraRules = ''
    ACTION=="add", \
      SUBSYSTEM=="hidraw", \
      KERNEL=="hidraw*", \
      ATTRS{idVendor}=="28de", \
      ATTRS{idProduct}=="2300", \
      TAG+="systemd", \
      ENV{SYSTEMD_WANTS}+="valve-index-reset@%k.service"
  '';
}
