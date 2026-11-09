{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    tree
    wget
    curl
    openssl
    btop
    ripgrep
    nh
    nix-output-monitor
    lftp
    uv
    distrobox
    bubblewrap
  ];

  environment.sessionVariables = {
    NH_FLAKE = "/etc/nixos";
  };
}
