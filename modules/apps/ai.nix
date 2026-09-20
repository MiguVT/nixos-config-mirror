{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.llama-cpp.override { cudaSupport = true; })
    pkgs.stable.opencode
  ];

  services.llama-cpp = {
    enable = true;
    package = (pkgs.llama-cpp.override { cudaSupport = true; });
    settings.port = 8001;
    settings.models-preset = (pkgs.formats.ini { }).generate "models-preset.ini" {
      "qwen3.8-27b" = {
        hf-repo = "unsloth/Qwen3.8-27B-GGUF:UD-Q4_K_XL";
        alias = "qwen3.8-27b";
        ctx-size = "65536";
        n-gpu-layers = "999";
        flash-attn = "on";
        cache-type-k = "q8_0";
        cache-type-v = "q8_0";
        cache-type-k-draft = "q8_0";
        cache-type-v-draft = "q8_0";
        batch-size = "2048";
        ubatch-size = "512";
        image-min-tokens = "1024";
        threads = "8";
        threads-batch = "8";
        spec-type = "draft-mtp";
        spec-draft-n-max = "2";
        reasoning = "on";
        reasoning-effort = "medium";
        no-reasoning-preserve = "on";
        temp = "1.0";
        top-p = "0.95";
        top-k = "20";
        min-p = "0.0";
        jinja = "on";
        parallel = "1";
        host = "0.0.0.0";
        port = "8001";
        api-key = "testkey";
      };
    };
  };

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
