{ pkgs, ... }:

{
  users.users.miguvt.packages = [
    pkgs.hydralauncher
  ];
}
