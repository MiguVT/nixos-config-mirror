{ ... }:

{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 30;
  };

  # zram is the only swap device on this machine, so the kernel defaults are
  # tuned for spinning disks: 60 keeps anonymous pages resident and lets zram
  # sit unused, and page-cluster 3 reads 8 pages ahead per swap fault, which is
  # wasted work when the backing store is RAM. Prefer the compressed device,
  # read exactly one page per fault.
  boot.kernel.sysctl = {
    "vm.swappiness" = 150;
    "vm.page-cluster" = 0;
  };
}
