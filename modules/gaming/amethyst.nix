{
  pkgs,
  lib,
  ...
}:

let
  amethystModManager =
    pkgs.python3Packages.buildPythonApplication (finalAttrs: {
      pname = "Amethyst-Mod-Manager";
      version = "1.3.11";
      format = "other";
      dontBuild = true;

      src = pkgs.fetchFromGitHub {
        owner = "ChrisDKN";
        repo = "Amethyst-Mod-Manager";
        rev = "v1.3.11";
        sha256 = "sha256-WqAYDCnzlpEWS+SXIpEGFw23yak7H0zgW4xqFAknRRQ=";
      };

      dependencies = with pkgs.python3Packages; [
        customtkinter
        py7zr
        libarchive-c
        pillow
        lz4
        zstandard
        requests
        websocket-client
        keyring
        jeepney
        importlib-metadata
        backports-tarfile
        msgpack
        bsdiff4
      ];

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        cp $src/src/gui.py $out/bin/Amethyst-Mod-Manager
        # gui.py ships without a shebang or exec bit; add both so the
        # wrapPythonPrograms hook in postFixUp wraps it into a runnable command.
        sed -i '1i #!/usr/bin/env python3' $out/bin/Amethyst-Mod-Manager
        chmod +x $out/bin/Amethyst-Mod-Manager
        runHook postInstall
      '';

      postFixUp = ''
        wrapPythonPrograms
      '';

      meta = {
        description = "A Linux native mod manager for a variety of games";
        homepage = "https://github.com/ChrisDKN/Amethyst-Mod-Manager";
        downloadPage = "https://github.com/ChrisDKN/Amethyst-Mod-Manager/releases";
        license = lib.licenses.gpl3;
        platforms = [ "x86_64-linux" ];
      };
    });
in
{
  environment.systemPackages = [ amethystModManager ];
}
