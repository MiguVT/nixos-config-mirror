{ pkgs, ... }:

{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      glibc
      openssl
      icu
      util-linux
      libglvnd
      libx11
      libxcursor
      libxrandr
      libxi
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  environment.systemPackages = with pkgs; [
    nil
    nixfmt
    gh
    jq
    gnumake
    gcc
    mono
    msbuild
    android-tools
  ];

  home-manager.users.miguvt = { pkgs, ... }: {
    programs.vscodium = {
      enable = true;

      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          arrterian.nix-env-selector
          eamodio.gitlens
          catppuccin.catppuccin-vsc
          pkief.material-icon-theme
          esbenp.prettier-vscode

          (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
            mktplcRef = {
              name = "opencode";
              publisher = "sst-dev";
              version = "0.0.13";
              hash = "sha256-6adXUaoh/OP5yYItH3GAQ7GpupfmTGaxkKP6hYUMYNQ=";
            };
            meta = {
              description = "OpenCode - terminal-based AI coding agent";
              homepage = "https://github.com/anomalyco/opencode";
              downloadPage =
                "https://marketplace.visualstudio.com/items?itemName=sst-dev.opencode";
              license = pkgs.lib.licenses.mit;
            };
          })

          (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
            mktplcRef = {
              name = "calagopus";
              publisher = "calagopus";
              version = "1.1.6";
              hash = "sha256-w/NyBWMeckS/jjz5zIR6FLjfTfhfyK76+0N8l+fFy00=";
            };
            meta = {
              description =
                "Browse and edit Calagopus server files and access the server console directly from VS Code.";
              homepage = "https://github.com/calagopus/vscode-extension";
              downloadPage =
                "https://marketplace.visualstudio.com/items?itemName=calagopus.calagopus";
              license = pkgs.lib.licenses.mit;
            };
          })
        ];

        userSettings = {
          "telemetry.telemetryLevel" = "off";
          "update.mode" = "none";

          # Set here to avoid read-only GUI errors
          "git.confirmSync" = false;
          "git.enableSmartCommit" = true;

          "workbench.colorTheme" = "Catppuccin Mocha";
          "workbench.iconTheme" = "material-icon-theme";
          "window.titleBarStyle" = "custom";
          "editor.fontFamily" = "'JetBrains Mono', 'Fira Code', monospace";
          "editor.fontLigatures" = true;
          "editor.formatOnSave" = true;

          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
          "nix.serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = [ "nixfmt" ];
              };
            };
          };
        };
      };
    };
  };
}
