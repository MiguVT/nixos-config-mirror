{ pkgs, ... }:

let
  catppuccinMochaPink = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/thunderbird/0289f3bd9566f9666682f66a3355155c0d0563fc/themes/mocha/mocha-pink.xpi";
    hash = "sha256-Fa49rVvFSTMV6Aujj2/UD7NePzjbNnP6xGr/Z02mOiA=";
  };

  # Exact ID from manifest.json
  addonId = "{aee472cc-993b-522a-b6e8-c904c250a8d9}";
in
{
  home-manager.users.miguvt = {
    programs.thunderbird = {
      enable = true;

      profiles.default = {
        isDefault = true;

        settings = {
          # Automatically enables side-loaded add-ons without prompting
          "extensions.autoDisableScopes" = 0;
        };
      };
    };

    # Symlinks the XPI into the Home Manager-managed profile
    home.file.".thunderbird/default/extensions/${addonId}.xpi".source = catppuccinMochaPink;
  };
}
