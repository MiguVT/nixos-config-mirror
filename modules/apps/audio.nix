{ pkgs, ... }:

{
  # Required by EasyEffects to persist settings/presets
  programs.dconf.enable = true;

  home-manager.users.miguvt = {
    home.packages = with pkgs; [
      # Effects chain
      calf
      deepfilternet
      dragonfly-reverb
      easyeffects
      lsp-plugins
      rnnoise

      # Recording and editing
      audacity
    ];

    services.easyeffects.enable = true;
  };

  # LV2/VST3 discovery for apps that run outside their Nix wrappers.
  environment.sessionVariables = {
    LV2_PATH = "$HOME/.nix-profile/lib/lv2:$HOME/.local/share/lv2";
    VST3_PATH = "$HOME/.nix-profile/lib/vst3:$HOME/.vst3";
  };
}
