{ pkgs, ... }:

{
  # scx_rusty as the system-wide scheduler (sched_ext)
  services.scx = {
    enable = false; # TODO: Wait for update, currently 1.1.2 -> 1.1.3 needed for scx_rusty work
    package = pkgs.scx.rustscheds;
    scheduler = "scx_rusty";
  };
}
