{ ... }:

{
  services.flatpak.enable = true;

  services.flatpak.remotes = [
    {
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }
    # GPG-signed; the key ships inside the flatpakrepo file itself.
    {
      name = "cordial";
      location = "https://luohoa97.github.io/cordial/cordial.flatpakrepo";
    }
  ];

  # Expose flatpak app export paths to desktop launchers
  home-manager.users.miguvt = { ... }: {
    home.file.".profile".text = ''
      export XDG_DATA_DIRS="$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"
    '';
  };
}
