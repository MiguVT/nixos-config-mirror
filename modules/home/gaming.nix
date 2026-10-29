{ config, pkgs, inputs, lib, ... }:

{
  home.packages = [
    pkgs.ares
    pkgs.melonds
    pkgs.azahar
    pkgs.dolphin-emu
    pkgs.cemu
    pkgs.eden
    pkgs.ryubing
    pkgs.pcsx2
    pkgs.rpcs3
    pkgs.shadps4
    pkgs.shadps4-qtlauncher
    pkgs.ppsspp
    pkgs.vita3k
    pkgs.xemu
    pkgs.xenia-canary
    pkgs.flycast
  ];

  # ES-DE settings file to set ROM path
  home.file."~/.config/ES-DE/es_settings.xml".text = ''
    <settings>
      <rompath>/mnt/data/OwnCloud/Emulating/Roms/</rompath>
    </settings>
  '';

  # Custom systems XML for ES-DE
  home.file."~/.config/ES-DE/custom_systems/es_systems.xml".source = pkgs.writeText "es_systems.xml" ''
    <systemList>
      <!-- Nintendo 3DS: use azahar (Citra fork) -->
      <system>
        <name>3ds</name>
        <fullname>Nintendo 3DS</fullname>
        <path>/mnt/data/OwnCloud/Emulating/Roms/3ds</path>
        <extension>.3ds .3dz .cia</extension>
        <command>${pkgs.azahar}/bin/azahar %ROM%</command>
        <platform>3ds</platform>
        <theme>3ds</theme>
      </system>
      <!-- Nintendo Switch (Yuzu fork): use eden -->
      <system>
        <name>switch</name>
        <fullname>Nintendo Switch</fullname>
        <path>/mnt/data/OwnCloud/Emulating/Roms/switch</path>
        <extension>.nsp .xci</extension>
        <command>${pkgs.eden}/bin/eden %ROM%</command>
        <platform>switch</platform>
        <theme>switch</theme>
      </system>
      <!-- Nintendo Switch (Ryujinx fork): use ryubing -->
      <system>
        <name>switch-ryujinx</name>
        <command>${pkgs.ryubing}/bin/ryubing %ROM%</command>
        <platform>switch</platform>
        <theme>switch</theme>
      </system>
      <!-- Sony PlayStation 4: use shadps4 -->
      <system>
        <name>ps4</name>
        <fullname>Sony PlayStation 4</fullname>
        <path>/mnt/data/OwnCloud/Emulating/Roms/ps4</path>
        <extension>.pkg .iso .bin</extension>
        <command>${pkgs.shadps4}/bin/shadps4 %ROM%</command>
        <platform>ps4</platform>
        <theme>ps4</theme>
      </system>
    </systemList>
  '';

  # SteamOS (Gamescope) launcher for vicinae/KDE app menu
  home.file."~/.local/share/applications/steamos-gamescope.desktop".text = ''
    [Desktop Entry]
    Name=SteamOS (Gamescope)
    Comment=Launch Steam Deck Gamepad UI inside Gamescope
    Exec=steamos-gamescope
    Icon=steam
    Type=Application
    Categories=Game
  '';
}