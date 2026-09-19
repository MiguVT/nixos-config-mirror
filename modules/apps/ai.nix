{ pkgs, inputs, ... }:

let
  pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config = {
      allowUnfree = true;
      cudaSupport = true;
    };
  };
in
{
  environment.systemPackages = [
    (pkgs-stable.llama-cpp.override { cudaSupport = true; })
    pkgs-stable.opencode
  ];

  environment.sessionVariables = {
    AI_MODELS_PATH = "/mnt/data/llamasrv/Models";
  };

  networking.firewall.allowedTCPPorts = [
    8001 # llama-server
  ];

  home-manager.users.miguvt = {
    xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      "provider" = {
        "local-llama" = {
          "npm" = "@ai-sdk/openai-compatible";
          "name" = "Local Llama Server";
          "options" = {
            "baseURL" = "http://127.0.0.1:8001/v1";
          };
          "models" = {
            "qwen3.8-27b" = {
              "name" = "qwen3.8-27b (local)";
            };
          };
        };
      };

      "tools" = {
        "bash" = true;
        "edit" = true;
        "write" = true;
        "read" = true;
      };
    };
  };
}
