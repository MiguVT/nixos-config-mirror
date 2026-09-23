{ pkgs, inputs, ... }:

let
  freesm = inputs.freesmlauncher.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home-manager.users.miguvt.home.packages = [
    (freesm.default.override {
      # Standard openjdk pack (8/17/21/25) silences the wrapper's jdk8 warning
      jdks = freesm.jvmPack.openjdk;
    })
    pkgs.mangohud
  ];

  # FreesmLauncher auto-detects these system JDKs. Keeping multiple versions
  # in Home Manager conflicts on shared paths such as lib/openjdk/bin/jar.
  environment.systemPackages = [
    pkgs.jdk21
    pkgs.jdk17
    pkgs.jdk8
  ];
}
