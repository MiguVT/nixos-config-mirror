{ pkgs, ... }:
let
  # Upstream standalone release; nixpkgs still ships opencode v1.
  opencode-v2 = pkgs.stdenvNoCC.mkDerivation {
    pname = "opencode";
    version = "2.0.6";
    src = pkgs.fetchurl {
      url = "https://opencode.ai/files/bin/2.0.6/opencode-linux-x64.tar.gz";
      sha256 = "833003213e155266c073ae3f19e2a63d027b9d66a8bc9a4610ec9c9d4b369c8d";
    };
    # Tarball contains only the top-level binary; stdenv's directory
    # detection aborts on file-only archives, so unpack into src/ ourselves.
    unpackPhase = ''
      runHook preUnpack
      mkdir src
      tar -xf "$src" -C src
      runHook postUnpack
    '';
    sourceRoot = "src";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/bin
      install -Dm755 opencode $out/bin/opencode
    '';
    meta = with pkgs.lib; {
      description = "AI coding agent built for the terminal";
      homepage = "https://opencode.ai";
      license = licenses.mit;
      platforms = [ "x86_64-linux" ];
      mainProgram = "opencode";
    };
  };
in
{
  environment.systemPackages = [
    (pkgs.llama-cpp.override { cudaSupport = true; })
    opencode-v2
  ];

  # TODO: Setup llama-cpp service

  environment.sessionVariables = {
    AI_MODELS_PATH = "/mnt/data/llamasrv/Models";
  };

  networking.firewall.allowedTCPPorts = [
    8001 # llama-server
  ];

  home-manager.users.miguvt = {
    xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      "model" = "local-llama/qwen3.8-27b";
      # NixOS-managed binary: do not let it self-update.
      "update" = "disable";

      "providers" = {
        "local-llama" = {
          "name" = "Local Llama Server";
          "package" = "@opencode/ai/providers/openai-compatible";
          "settings" = {
            "baseURL" = "http://127.0.0.1:8001/v1";
          };
          "models" = {
            "qwen3.8-27b" = {
              "name" = "qwen3.8-27b (local)";
              "limit" = {
                "context" = 65536;
                "output" = 8192;
              };
            };
          };
        };
      };
    };
  };
}
