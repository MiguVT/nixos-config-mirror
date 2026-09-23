{ pkgs, ... }:

{
  home-manager.users.miguvt.home.packages = with pkgs; [
    kdePackages.kate
    audacity
    lsp-plugins
    deepfilternet
    dragonfly-reverb
    calf
    upscayl
  ];

  environment.sessionVariables = {
    LV2_PATH = "$HOME/.nix-profile/lib/lv2:$HOME/.local/share/lv2";
    VST3_PATH = "$HOME/.nix-profile/lib/vst3:$HOME/.vst3";
  };
}
