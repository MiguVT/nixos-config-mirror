{ inputs, ... }:

{
  home-manager.users.miguvt = { pkgs, ... }: {
    programs.vicinae = {
      enable = true;

      systemd = {
        enable = true;
        autoStart = true;
        environment = {
          USE_LAYER_SHELL = "1";
        };
      };

      settings = {
        close_on_focus_loss = true;
        consider_preedit = true;
        pop_to_root_on_close = true;
        favicon_service = "twenty";
        search_files_in_root = true;

        launcher_window = {
          opacity = 0.98;
        };

        theme = {
          dark = {
            name = "vicinae-dark";
            icon_theme = "default";
          };
        };
      };

      extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
        # bluetooth -> Doesnt work need fix
        nix
        power-profile
      ];
    };
  };
}
