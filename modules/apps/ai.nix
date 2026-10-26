{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.llama-cpp.override { cudaSupport = true; })
    pkgs.opencode
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
    };
  };
}
