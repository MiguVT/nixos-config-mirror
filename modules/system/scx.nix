{ pkgs, ... }:

{
  # Rust-based sched-ext schedulers (scx_rusty, scx_p2pq, scxtop, ...)
  environment.systemPackages = [ pkgs.scx.rustscheds ];

  # scx_rusty as the system-wide scheduler (sched_ext)
  systemd.services.scx_rusty = {
    description = "SCX Rusty Scheduler";
    after = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.scx.rustscheds}/bin/scx_rusty";
    };
  };
}
