{ pkgs, inputs, ... }:

{
  home-manager.users.miguvt.home.packages = [
    # Pinned via flake.lock; see inputs.creamlinux-installer in flake.nix.
    (import inputs.creamlinux-installer { inherit pkgs; })
  ];
}
