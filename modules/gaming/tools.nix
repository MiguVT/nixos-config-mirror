{ pkgs, ... }:

{
  # Companion tools for games installed outside of Steam.
  home-manager.users.miguvt.home.packages = [
    pkgs.bs-manager # Beat Saber mod manager
    pkgs.ludusavi # Savegame backups
    pkgs.oversteer # Logitech G29 wheel configuration
  ];
}
