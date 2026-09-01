{ pkgs, inputs, ... }:

{
  environment.systemPackages = [
    inputs.freesmlauncher.packages.${pkgs.stdenv.hostPlatform.system}.default

    (pkgs.prismlauncher.override {
      jdks = [
        pkgs.jdk21 # MC 1.20.5+
        pkgs.jdk17 # MC 1.18 - 1.20.4
        pkgs.jdk8 # MC 1.16.5 and older
      ];
    })

    # Auto-detected by FreesmLauncher
    pkgs.jdk21
    pkgs.jdk17
    pkgs.jdk8

    pkgs.mangohud
  ];
}
