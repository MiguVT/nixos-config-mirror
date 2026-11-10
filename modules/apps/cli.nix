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
    mullvad-vpn
  ];

  environment.sessionVariables = {
    NH_FLAKE = "/etc/nixos";
  };
}
