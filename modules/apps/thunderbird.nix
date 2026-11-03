{ pkgs, ... }:

let
  catppuccinMochaPink = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/thunderbird/0289f3bd9566f9666682f66a3355155c0d0563fc/themes/mocha/mocha-pink.xpi";
    hash = "sha256-Fa49rVvFSTMV6Aujj2/UD7NePzjbNnP6xGr/Z02mOiA=";
  };

  # Thunderbird MCP bridge add-on. Keep `version` in sync with `thunderbirdMcp`
  # in ai.nix: the XPI and the stdio bridge speak the same protocol.
  # Upstream: https://github.com/TKasperczyk/thunderbird-mcp
  thunderbirdMcpVersion = "0.10.0";
  thunderbirdMcpAddon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/TKasperczyk/thunderbird-mcp/v${thunderbirdMcpVersion}/dist/thunderbird-mcp.xpi";
    hash = "sha256-z+jzyBZ/YD+hM4Tz2pquboHFeYBzaG9/ntbQoUN40us=";
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

    # Side-loads the add-on that the `thunderbird` MCP server in ai.nix talks to.
    # `force` because the add-on auto-updates itself from its update_url and
    # replaces the symlink with a real file.
    home.file.".thunderbird/default/extensions/thunderbird-mcp@tkasperczyk.dev.xpi" = {
      source = thunderbirdMcpAddon;
      force = true;
    };
  };
}
