{
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    # Hardware
    ./modules/hardware/bluetooth.nix
    ./modules/hardware/cpu.nix
    ./modules/hardware/lg4ff.nix
    ./modules/hardware/madmouse.nix
    ./modules/hardware/nvidia.nix
    ./modules/hardware/openrgb.nix
    ./modules/hardware/printer.nix
    ./modules/hardware/razer.nix
    ./modules/hardware/storage.nix

    # Gaming
    ./modules/gaming/amethyst.nix
    ./modules/gaming/creamlinux.nix
    ./modules/gaming/games.nix
    ./modules/gaming/launchers.nix
    ./modules/gaming/macos.nix
    ./modules/gaming/minecraft.nix
    ./modules/gaming/roblox.nix
    ./modules/gaming/steam.nix
    ./modules/gaming/sunshine.nix
    ./modules/gaming/tools.nix
    ./modules/gaming/valve-index.nix
    ./modules/gaming/vr.nix
    ./modules/gaming/xbox.nix

    # System
    ./modules/system/audio.nix
    ./modules/system/building.nix
    ./modules/system/display.nix
    ./modules/system/firewall.nix
    ./modules/system/forgejo.nix
    ./modules/system/limine.nix
    ./modules/system/locale.nix
    ./modules/system/maintenance.nix
    ./modules/system/mullvad.nix
    ./modules/system/nix.nix
    ./modules/system/nix-ld.nix
    ./modules/system/scx.nix
    ./modules/system/sops.nix
    ./modules/system/zram.nix

    # Applications
    ./modules/apps/ai.nix
    ./modules/apps/alcom.nix
    ./modules/apps/archive.nix
    ./modules/apps/audio.nix
    ./modules/apps/bitwarden.nix
    ./modules/apps/chat.nix
    ./modules/apps/chromium.nix
    ./modules/apps/cli.nix
    ./modules/apps/dev.nix
    ./modules/apps/editor.nix
    ./modules/apps/firefox.nix
    ./modules/apps/flatpak.nix
    ./modules/apps/fun.nix
    ./modules/apps/git.nix
    ./modules/apps/graphics.nix
    ./modules/apps/isoimagewriter.nix
    ./modules/apps/launcher.nix
    ./modules/apps/maps.nix
    ./modules/apps/media.nix
    ./modules/apps/monero.nix
    ./modules/apps/office.nix
    ./modules/apps/phone.nix
    ./modules/apps/streaming.nix
    ./modules/apps/terminal.nix
    ./modules/apps/thunderbird.nix
    ./modules/apps/tor.nix
    ./modules/apps/virt-manager.nix
    ./modules/apps/virt-viewer.nix
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
      "vista-fonts"
      "sm64coopdx"
      "baserom.us.z64"
      "cccl"
      "cuda_cudart"
      "cuda_nvcc"
      "libnvvm"
      "cuda_crt"
      "libcublas"
      "cuda_nvrtc"
      "hytale-launcher"
      "rpcs3"
    ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  users.users."miguvt" = {
    isNormalUser = true;
    description = "MiguVT";
    extraGroups = [
      "networkmanager"
      "wheel"
      "uinput"
    ];
  };

  system.stateVersion = "26.05";
}
