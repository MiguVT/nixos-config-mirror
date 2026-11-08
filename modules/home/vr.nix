{ config, pkgs, ... }:

{
  # Sandboxed Steam games cannot see the system /etc/xdg runtime manifest, so
  # publish it in the user config dir where pressure-vessel imports it from
  # (PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1 in steam.nix).
  xdg.configFile."openxr/1/active_runtime.json".source =
    "${pkgs.monado}/share/openxr/1/openxr_monado.json";

  # Point the OpenVR runtime at xrizer so OpenVR apps run on Monado without SteamVR
  xdg.configFile."openvr/openvrpaths.vrpath".text =
    let
      steam = "${config.xdg.dataHome}/Steam";
    in
    builtins.toJSON {
      version = 1;
      jsonid = "vrpathreg";

      external_drivers = null;
      config = [ "${steam}/config" ];

      log = [ "${steam}/logs" ];

      runtime = [
        "${pkgs.xrizer}/lib/xrizer"
        # 32-bit vrclient lives in a separate store prefix; games pick the
        # entry matching their bitness.
        "${pkgs.pkgsi686Linux.xrizer}/lib/xrizer"
      ];
    };
}
