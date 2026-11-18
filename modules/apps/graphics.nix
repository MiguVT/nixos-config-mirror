{ pkgs, ... }:

let
  # fetchzip strips the top-level "PhotoGIMP-linux" dir (stripRoot),
  # so the unpacked home-dir layout sits directly at the output root
  photoGimp = pkgs.fetchzip {
    url = "https://github.com/Diolinux/PhotoGIMP/releases/download/3.1/PhotoGIMP-linux.zip";
    # hash of the unpacked tree (fetchzip uses recursiveHash), not the zip
    sha256 = "6b236130b8d28d84497340c3ffca2a29dd213861cb518068adae3ec6d562fe24";
  };

  # Region screenshot -> OCR -> clipboard (bind to a key in Plasma shortcuts)
  ocr-clip = pkgs.writeShellApplication {
    name = "ocr-clip";
    runtimeInputs = with pkgs; [
      kdePackages.spectacle
      tesseract
      tesseract.languages.all
      wl-clipboard
      libnotify
    ];
    text = ''
      # languages.all is data-only (traineddata); point tesseract at it
      export TESSDATA_PREFIX="${pkgs.tesseract.languages.all}"
      # default covers the main languages; pass e.g. "eng+spa+fra" for more
      lang="''${1:-eng+spa}"
      tmp="$(mktemp --suffix=.png)"
      trap 'rm -f "$tmp"' EXIT

      # region-select screenshot, background, no notification
      if ! spectacle -r -b -n -o "$tmp"; then
        exit 1
      fi

      if ! text="$(tesseract "$tmp" - -l "$lang" 2>/dev/null)"; then
        notify-send "OCR" "tesseract failed (langs: $lang)"
        exit 1
      fi
      [ -n "$text" ] || { notify-send "OCR" "no text recognized"; exit 1; }
      printf '%s' "$text" | wl-copy
      notify-send "OCR" "copied $(printf '%s' "$text" | wc -c) bytes to clipboard"
    '';
  };

  ocr-clip-desktop = pkgs.makeDesktopItem {
    name = "ocr-clip";
    desktopName = "OCR clip (Spectacle region)";
    exec = "ocr-clip eng+spa";
    icon = "edit-find-replace";
    categories = [ "Utility" ];
  };

in

{
  home-manager.users.miguvt = {
    home.packages = with pkgs; [
      gimp-with-plugins
      upscayl
      ocr-clip
      ocr-clip-desktop
      # NormCap: region-select -> OCR -> clipboard in one flow (uses its own
      # tesseract with eng+spa by default; faster than the ocr-clip script)
      normcap
    ];

    # Autostart NormCap in tray at login: it stays resident in RAM, so the
    # ~1-2s Python/tesseract startup happens once instead of on every capture
    systemd.user.services.normcap-tray = {
      Unit = {
        Description = "NormCap OCR tray (autostart, resident)";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.normcap}/bin/normcap --background-mode";
        Restart = "on-failure";
        RestartSec = 2;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

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
