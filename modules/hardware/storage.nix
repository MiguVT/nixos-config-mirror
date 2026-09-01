{ ... }:

{
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/748e2f8b-c6e5-4af9-9242-d2d8065782c8";
    fsType = "btrfs";
    options = [ "nofail" "compress=zstd" "noatime" ];
  };
}
