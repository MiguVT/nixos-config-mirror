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
