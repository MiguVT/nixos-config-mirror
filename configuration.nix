{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/hardware/storage.nix
    ./modules/hardware/cpu.nix
    ./modules/hardware/nvidia.nix
    ./modules/hardware/bluetooth.nix
    ./modules/hardware/printer.nix
    ./modules/hardware/openrgb.nix
    ./modules/gaming/gale.nix
    ./modules/gaming/amethyst.nix
    ./modules/gaming/steam.nix
    ./modules/gaming/minecraft.nix
    ./modules/gaming/index.nix
    ./modules/gaming/roblox.nix
    ./modules/gaming/vr.nix
    ./modules/system/nix.nix
    ./modules/system/zram.nix
    ./modules/system/scx.nix
    ./modules/system/locale.nix
    ./modules/system/audio.nix
    ./modules/system/maintenance.nix
    ./modules/system/display.nix
    ./modules/system/mullvad.nix
    ./modules/system/firewall.nix
    ./modules/apps/firefox.nix
    ./modules/apps/terminal.nix
    ./modules/apps/cli.nix
    ./modules/apps/git.nix
    ./modules/apps/bitwarden.nix
    ./modules/apps/chat.nix
    ./modules/apps/launcher.nix
    ./modules/apps/dev.nix
    ./modules/apps/easyeffects.nix
    ./modules/apps/flatpak.nix
    ./modules/apps/ai.nix
    ./modules/apps/streaming.nix
    ./modules/apps/music.nix
    ./modules/apps/office.nix
    ./modules/apps/thunderbird.nix
    ./modules/apps/graphics.nix
    ./modules/apps/alcom.nix
    ./modules/apps/isoimagewriter.nix
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    let
      name = lib.getName pkg;
    in
    builtins.elem name [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
      "unityhub"
      "corefonts"
    ]
    # Catches cuda, cudnn, libcublas, libcufft, etc.
    || builtins.match ".*(cuda|cudnn|libcu).*" name != null;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  users.users."miguvt" = {
    isNormalUser = true;
    description = "MiguVT";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ kdePackages.kate ];
  };

  system.stateVersion = "26.05";
}
