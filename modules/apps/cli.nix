{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tree
    wget
    curl
    btop
    ripgrep
    nh
    nix-output-monitor
    sshfs
  ];

  environment.sessionVariables = {
    NH_FLAKE = "/etc/nixos";
  };
}
