{
  pkgs,
  ...
}:
# DaVinci Resolve Studio with license patches applied to bin/resolve.
# The real binary lives in the inner `davinci` derivation (exposed via
# passthru); the nixpkgs package.nix does not accept a `davinci` parameter,
# so we callPackage it directly and wrap stdenv.mkDerivation to hook the
# patch into the inner derivation's postInstall.

# I love that davinciresolve studio is one-time payment and I promise I
# will buy it when able but currently I dont have the money 🙏
let
  davinci-resolve-studio =
    pkgs.callPackage "${pkgs.path}/pkgs/by-name/da/davinci-resolve/package.nix"
      {
        studioVariant = true;
        stdenv = pkgs.stdenv // {
          mkDerivation =
            args:
            pkgs.stdenv.mkDerivation (
              args
              // {
                nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ pkgs.perl ];
                postInstall = (args.postInstall or "") + ''
                  # ffmpeg decode patches for bin/resolve
                  perl -pi -e 's/\x03\x00\x89\x45\xFC\x83\x7D\xFC\x00\x74\x11\x48\x8B\x45\xC8\x8B/\x03\x00\x89\x45\xFC\x83\x7D\xFC\x00\xEB\x11\x48\x8B\x45\xC8\x8B/g' $out/bin/resolve
                  perl -pi -e 's/\x74\x11\x48\x8B\x45\xC8\x8B\x55\xFC\x89\x50\x58\xB8\x00\x00\x00/\xEB\x11\x48\x8B\x45\xC8\x8B\x55\xFC\x89\x50\x58\xB8\x00\x00\x00/g' $out/bin/resolve
                  perl -0777 -pi -e 's/(\x40\x84\xED)\x74(.\xBF\x16\x00\x00\x00\xBE.\x01\x00\x00\xE8)/$1\x75$2/g' $out/bin/resolve
                  mkdir -p $out/.license
                  echo -e "LICENSE blackmagic davinciresolvestudio 999999 permanent uncounted\n hostid=ANY issuer=CGP customer=CGP issued=28-dec-2023\n akey=0000-0000-0000-0000 _ck=00 sig=\"00\"" > $out/.license/blackmagic.lic
                '';
              }
            );
        };
      };
in
{
  environment.systemPackages = [
    davinci-resolve-studio
  ];
}
