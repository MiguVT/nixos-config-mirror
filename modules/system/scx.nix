{ pkgs, ... }:

{
  # scx_cosmos as the system-wide scheduler (sched_ext)
  # Cosmos handles multi-domain / multi-L3 topologies (Ryzen 9 5950X) better than lavd.
  # On 1.1.3+ release on nixpkgs move to scx_rust (1.1.2 broke scx_rusty with userspace crashes).
  services.scx = {
    enable = true;
    package = pkgs.scx.rustscheds;
    scheduler = "scx_cosmos";
  };
}
