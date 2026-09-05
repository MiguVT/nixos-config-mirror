{ pkgs, ... }:

{
  # scx_lavd as the system-wide scheduler (sched_ext)
  services.scx = {
    enable = true;
    package = pkgs.scx.rustscheds;
    scheduler = "scx_lavd";
  };
}
