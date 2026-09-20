{ pkgs, inputs, ... }:

let
  freesm = inputs.freesmlauncher.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  users.users.miguvt.packages = [
    (freesm.default.override {
      # Standard openjdk pack (8/17/21/25) silences the wrapper's jdk8 warning
      jdks = freesm.jvmPack.openjdk;
    })
  ];

  environment.systemPackages = [
    # Auto-detected by FreesmLauncher
    pkgs.jdk21
    pkgs.jdk17
    pkgs.jdk8

    pkgs.mangohud
  ];
}
