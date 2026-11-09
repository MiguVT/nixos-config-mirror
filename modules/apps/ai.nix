{ config, pkgs, ... }:
let
  # Shared between the session environment and the systemd service, which does
  # not inherit `environment.sessionVariables`.
  aiModelsPath = "/mnt/data/llamasrv/Models";

  llamaCppCuda = pkgs.llama-cpp.override { cudaSupport = true; };

  # Moodle MCP server — exposes Moodle Web Services over stdio to MCP clients.
  # Upstream: https://github.com/G36maid/moodle-mcp (no flake; built from source)
  moodleMcp = pkgs.rustPlatform.buildRustPackage rec {
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
    # nixpkgs' cargo-setup-hook forces AWS_LC_SYS_USE_SYSTEM=1 (system AWS-LC),
    # which isn't available in the sandbox. Opt out so aws-lc-sys builds from
    # source.
    dontCargoUseSystemLibs = true;
    # Test suite requires system CA certs + network access; skip in sandbox.
    doCheck = false;
  };

  # nixpkgs 2.2.5 ships a single Darwin-generated node_modules hash; upstream
  # fixed it per platform in c399e1b7fb but nixos-unstable has not picked that
  # up yet. Drop this override once the nixpkgs pin includes the fix.
  opencode = pkgs.opencode.overrideAttrs (old: {
    node_modules = old.node_modules.overrideAttrs (_: {
      outputHash = "sha256-prx9dX7kUvs/E3zopkaPk5LXh3xJAy5sZeum/W8L7cA=";
    });
  });

  # Thunderbird MCP bridge — Node stdio<->HTTP proxy for the Thunderbird add-on.
  # Upstream: https://github.com/TKasperczyk/thunderbird-mcp (no flake; no runtime deps)
  thunderbirdMcp = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "thunderbird-mcp";
    version = "0.10.0";
    src = pkgs.fetchFromGitHub {
      owner = "TKasperczyk";
      repo = "thunderbird-mcp";
      rev = "v${version}";
      hash = "sha256-FD2LIjexc8/qOlfX6fL/3/HWf0kdjx+gNug6WBW9unw=";
    };
    installPhase = ''
      mkdir -p $out/lib/thunderbird-mcp
      cp mcp-bridge.cjs package.json $out/lib/thunderbird-mcp/
    '';
  };
in
{
  environment.systemPackages = [
    llamaCppCuda
    opencode
    moodleMcp
  ];

  environment.sessionVariables = {
    AI_MODELS_PATH = aiModelsPath;
  };

  networking.firewall.allowedTCPPorts = [
    8001 # llama-server
  ];

  # Systemd daemon running llama-server in the background
  systemd.services.llama-server = {
    description = "Llama.cpp OpenAI-Compatible Server for Qwen3.8-27B";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    # Not enabled: start manually with `systemctl start llama-server`.
    # The model cache lives on /mnt/data; do not start before it is mounted.
    unitConfig.RequiresMountsFor = aiModelsPath;
    # System units do not inherit `environment.sessionVariables`. llama.cpp
    # resolves `-hf` downloads from LLAMA_CACHE (default: ~/.cache/llama.cpp).
    environment = {
      LLAMA_CACHE = aiModelsPath;
    };
    serviceConfig = {
      User = "miguvt";
      Group = "users";
      Restart = "always";
      RestartSec = "5s";
      # Grants the service access to CUDA devices
      SupplementaryGroups = [
        "video"
        "render"
      ];
      # Fail closed instead of starting an unauthenticated server.
      ExecStartPre = "${pkgs.coreutils}/bin/test -s ${config.sops.secrets."llama_key".path}";
      ExecStart = ''
        ${llamaCppCuda}/bin/llama-server \
          -hf unsloth/Qwen3.8-27B-GGUF:UD-Q4_K_XL \
          --alias "qwen3.8-27b" \
          --ctx-size 65536 \
          --image-min-tokens 1024 \
          --fit on --fit-target 768 \
          --flash-attn on \
          --cache-type-k q4_0 --cache-type-v q4_0 \
          --batch-size 4096 --ubatch-size 512 \
          --spec-type draft-mtp --spec-draft-n-max 3 --spec-draft-p-min 0.75 \
          --no-reasoning-preserve \
          --jinja \
          --parallel 1 \
          --api-key-file ${config.sops.secrets."llama_key".path} \
          --host 0.0.0.0 --port 8001
      '';
    };
  };

  home-manager.users.miguvt = {
    xdg.configFile."opencode/opencode.json" = {
      source = (pkgs.formats.json { }).generate "opencode.json" {
        "$schema" = "https://opencode.ai/config.json";

        # Default model for deep reasoning & planning
        "model" = "local-llama/qwen3.8-27b";
        # V2 equivalent of V1 `small_model`: the built-in title agent.
        "agents" = {
          "title" = {
            "model" = "local-llama/qwen3.8-27b-fast";
          };
        };

        # NixOS-managed binary: do not let it self-update.
        "update" = "disable";

        "providers" = {
          "local-llama" = {
            "name" = "Local Llama Server";
            "package" = "@opencode/ai/providers/openai-compatible";
            "settings" = {
              "baseURL" = "http://127.0.0.1:8001/v1";
              # Read at runtime; the key is never copied into the Nix store.
              "apiKey" = "{file:${config.sops.secrets."llama_key".path}}";
            };
            "models" = {
              # 1. Thinking Mode (Medium effort, Temp 1.0, Top-P 0.95)
              "qwen3.8-27b" = {
                "name" = "Qwen 3.8 27B (Thinking)";
                "limit" = {
                  "context" = 65536;
                  "output" = 8192;
                };
                "capabilities" = {
                  "tools" = true;
                  "reasoning" = {
                    "supported" = true;
                    "effort" = [
                      "none"
                      "low"
                      "medium"
                      "high"
                      "xhigh"
                    ];
                  };
                };
                "settings" = {
                  "reasoningEffort" = "medium";
                };
                "body" = {
                  "temperature" = 1.0;
                  "top_p" = 0.95;
                  "top_k" = 20;
                  "min_p" = 0.0;
                };
              };

              # 2. Instruct / Fast Mode (Reasoning disabled, Temp 0.7, Presence Penalty 1.5)
              "qwen3.8-27b-fast" = {
                "name" = "Qwen 3.8 27B (Instruct / Fast)";
                "modelID" = "qwen3.8-27b"; # Points to the same llama-server model alias
                "limit" = {
                  "context" = 65536;
                  "output" = 8192;
                };
                "capabilities" = {
                  "tools" = true;
                  "reasoning" = {
                    "supported" = false;
                  };
                };
                "settings" = {
                  "reasoningEffort" = "none";
                };
                "body" = {
                  "temperature" = 0.7;
                  "top_p" = 0.80;
                  "presence_penalty" = 1.5;
                };
              };
            };
          };
        };

        "mcp" = {
          "servers" = {
            "thunderbird" = {
              "type" = "local";
              "command" = [
                "${pkgs.nodejs}/bin/node"
                "${thunderbirdMcp}/lib/thunderbird-mcp/mcp-bridge.cjs"
              ];
            };
          };
        };

        "plugins" = [
          "@upstash/context7-opencode"
          "envsitter-guard@latest"
        ];
      };
      force = true;
    };
  };
}
