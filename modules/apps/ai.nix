{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.llama-cpp.override { cudaSupport = true; })
    pkgs.opencode
    # Moodle MCP server — exposes Moodle Web Services over stdio to MCP clients.
    # Upstream: https://github.com/G36maid/moodle-mcp (no flake; built from source)
    (pkgs.rustPlatform.buildRustPackage rec {
      pname = "moodle-mcp";
      version = "0.2.1";
      src = pkgs.fetchFromGitHub {
        owner = "G36maid";
        repo = "moodle-mcp";
        rev = "v${version}";
        sha256 = "1lhnr221z2ld20j790lb20zyq9h04nmc5kmkr48jwnrsbsnfsqdg";
      };
      nativeBuildInputs = [ pkgs.pkg-config ];
      buildInputs = [ pkgs.openssl ];
      cargoHash = "sha256-zIyZM5IiHu95/Wmo3VSwVyF3fRIcXkCMCwsU9aRO9n4=";
      # Test suite requires system CA certs + network access; skip in sandbox.
      doCheck = false;
    })
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
            "reasoningEffort" = "medium";
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
      "plugins" = [
        "@upstash/context7-opencode"
        "envsitter-guard@latest"
        "github:JRedeker/opencode-morph-fast-apply#v1.12.0"
      ];
    };
  };
}
