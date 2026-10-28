{ pkgs, ... }:

{
  programs.fish.enable = true;
  users.users."miguvt".shell = pkgs.fish;

  home-manager.users.miguvt = { pkgs, ... }: {
    home.packages = with pkgs; [
      kitty
    ];
  };
  # kitty will be removed in a future revision
}
