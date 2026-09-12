{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # 7z backend for Ark
    p7zip
    # Unrar backend (unar because unrar isnt FOSS)
    unar
  ];
}
