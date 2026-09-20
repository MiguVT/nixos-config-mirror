{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lazygit
  ];

  home-manager.users.miguvt = { ... }: {
    programs.git = {
      enable = true;
      lfs.enable = true;

      settings = {
        user = {
          name = "MiguVT";
          email = "contacto@miguvt.com";
        };
        init.defaultBranch = "main";
        pull.rebase = false;
        core.editor = "nano";
      };
    };
  };
}
