{ ... }:

{
  # CPU & Build Tuning for Ryzen 9 5950X (16C/32T) + 64GB RAM
  nix.settings = {
    # Bound aggregate compile parallelism to the 5950X's 32 logical threads.
    max-jobs = 2;

    # Two concurrent builds may each use up to 16 threads.
    cores = 16;
  };
}
