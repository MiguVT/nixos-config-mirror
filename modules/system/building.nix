{ ... }:

{
  # !!! TARGETED FOR MY CURRENT CPU + RAM (Ryzen 9 5950x 64GB RAM) - IF I CHANGE PC CHANGE THIS !!!
  nix.settings = {
    max-jobs = 1;
    cores = 12;
  };

  zramSwap.enable = true;
}
