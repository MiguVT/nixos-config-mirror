{ pkgs, ... }:

let
  # fetchzip strips the top-level "PhotoGIMP-linux" dir (stripRoot),
  # so the unpacked home-dir layout sits directly at the output root
  photoGimp = pkgs.fetchzip {
    url = "https://github.com/Diolinux/PhotoGIMP/releases/download/3.1/PhotoGIMP-linux.zip";
    # hash of the unpacked tree (fetchzip uses recursiveHash), not the zip
    sha256 = "6b236130b8d28d84497340c3ffca2a29dd213861cb518068adae3ec6d562fe24";
  };

in

{
  home-manager.users.miguvt = {
    home.packages = with pkgs; [
      gimp-with-plugins
    ];

    # PhotoGIMP 3.1 theme profile (Diolinux/PhotoGIMP).
    # GIMP rewrites gimprc/sessionrc at runtime and cannot write through a
    # symlink into the nix store, so seed the profile once into a
    # user-owned directory instead of linking it
    home.activation.gimpPhotogimpProfile = {
      data = ''
        gimpProfileDir="$HOME/.config/GIMP/3.2"
        if [ -L "$gimpProfileDir" ]; then
          run rm "$gimpProfileDir"
        fi
        if [ ! -d "$gimpProfileDir" ]; then
          run mkdir -p "$gimpProfileDir"
          run cp -r ${photoGimp}/.config/GIMP/3.0/. "$gimpProfileDir"/
          run chmod -R u+w "$gimpProfileDir"
        fi
      '';
      after = [ "linkGeneration" ];
      before = [ ];
    };
  };
}
