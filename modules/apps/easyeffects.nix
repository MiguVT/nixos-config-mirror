{ pkgs, ... }:

{
  # Required by EasyEffects to persist settings/presets
  programs.dconf.enable = true;

  home-manager.users.miguvt = {
    home.packages = with pkgs; [
      easyeffects
      rnnoise
      lsp-plugins
      calf
    ];

    services.easyeffects.enable = true;
  };
}
