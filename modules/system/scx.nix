{ pkgs, ... }:

{
  # scx_cosmos as the system-wide scheduler (sched_ext)
  # Cosmos handles multi-domain / multi-L3 topologies (Ryzen 9 5950X) better than lavd.
  # scx-loader (1.1.3) lets schedulers be switched at runtime with scxctl, no rebuild needed.
  services.scx-loader = {
    enable = true;
    schedsPackages = [ pkgs.scx.rustscheds ];
    config.default_sched = "scx_cosmos";
  };
}
