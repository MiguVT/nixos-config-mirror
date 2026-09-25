{
  lib,
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
    ./modules/hardware/razer.nix
    ./modules/hardware/lg4ff.nix
    ./modules/gaming/gale.nix
    ./modules/gaming/amethyst.nix
    ./modules/gaming/lutris.nix
    ./modules/gaming/ludusavi.nix
    ./modules/gaming/oversteer.nix
    ./modules/gaming/steam.nix
    ./modules/gaming/minecraft.nix
    ./modules/gaming/index.nix
    ./modules/gaming/roblox.nix
    ./modules/gaming/hydralauncher.nix
    ./modules/gaming/heroic.nix
    ./modules/gaming/vr.nix
    ./modules/system/nix.nix
    ./modules/system/zram.nix
    ./modules/system/scx.nix
    ./modules/system/sops.nix
    ./modules/system/locale.nix
    ./modules/system/audio.nix
    ./modules/system/maintenance.nix
    ./modules/system/display.nix
    ./modules/system/mullvad.nix
    ./modules/system/firewall.nix
    ./modules/system/forgejo.nix
    ./modules/system/building.nix
    ./modules/apps/firefox.nix
    ./modules/apps/chromium.nix
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
    ./modules/apps/media.nix
    ./modules/apps/editor.nix
    ./modules/apps/office.nix
    ./modules/apps/thunderbird.nix
    ./modules/apps/graphics.nix
    ./modules/apps/maps.nix
    ./modules/apps/alcom.nix
    ./modules/apps/isoimagewriter.nix
    ./modules/apps/archive.nix
    ./modules/apps/phone.nix
    ./modules/apps/monero.nix
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    let
      name = lib.getName pkg;
    in
    lib.elem name [
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
  };

  system.stateVersion = "26.05";
}
