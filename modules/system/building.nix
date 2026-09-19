{ ... }:

{
  # CPU & Build Tuning for Ryzen 9 5950X (16C/32T) + 64GB RAM
  nix.settings = {
    # 'auto' lets Nix dynamically scale concurrent package builds based on available cores
    max-jobs = "auto";

    # '0' tells make/ninja/cargo to utilize all 32 logical threads per job
    cores = 0;
  };

  # Compressed RAM swap to guarantee stability during heavy parallel builds
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}
