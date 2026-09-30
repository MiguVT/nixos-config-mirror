{ pkgs, ... }:

{
  # ALCOM (free, MIT) manages VRChat Unity projects; Unity Hub (unfree) installs
  # the editors ALCOM launches. Unity Hub is allowlisted in configuration.nix.
  # Unity editors get their shared libraries from the system-wide nix-ld
  # (modules/system/nix-ld.nix).
  home-manager.users.miguvt.home.packages = with pkgs; [
    alcom
    unityhub
  ];
}
