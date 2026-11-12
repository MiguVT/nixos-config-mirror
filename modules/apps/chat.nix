{ ... }:

{
  home-manager.users.miguvt = { pkgs, inputs, ... }: {
    home.packages = with pkgs; [
      vesktop
      ayugram-desktop
      whatsie
      mumble

      # Discord-only yapfast; not in nixpkgs, built from upstream flake.
      inputs.yapfast.packages.${pkgs.stdenv.hostPlatform.system}.yapfast
    ];
  };
}
