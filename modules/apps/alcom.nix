{ pkgs, ... }:

{
  # ALCOM (free, MIT) manages VRChat Unity projects; Unity Hub (unfree) installs
  # the editors ALCOM launches. Unity Hub is allowlisted in configuration.nix.
  home-manager.users.miguvt.home.packages = with pkgs; [
    alcom
    unityhub
    # Wraps an installed Unity editor binary so ALCOM launches it through
    # steam-run (Steam/FHS env). Run once after installing an editor in
    # Unity Hub:
    #   wrap-unity-steam                  # wrap every installed editor
    #   wrap-unity-steam <editor-dir>     # wrap a specific editor
    (writeShellScriptBin "wrap-unity-steam" ''
      set -euo pipefail
      shopt -s nullglob

      data_home="$XDG_DATA_HOME"
      [ -n "$data_home" ] || data_home="$HOME/.local/share"
      unity_root="$data_home/unity3d/Unity/Hub/Editor"

      steam_run="$(command -v steam-run || true)"
      if [ -z "$steam_run" ]; then
        echo "error: steam-run not found in PATH" >&2
        exit 1
      fi

      count=0
      wrap_one() {
        local d="$1" bin real
        bin="$d/Unity"
        real="$d/Unity.real"
        if [ ! -e "$bin" ]; then
          echo "skip (missing binary): $bin" >&2
          return
        fi
        if [ -e "$real" ]; then
          echo "already wrapped: $bin" >&2
          return
        fi
        mv "$bin" "$real"
        printf '#!/usr/bin/env bash\\nexec %q %q "$@"\\n' "$steam_run" "$real" > "$bin"
        chmod +x "$bin"
        echo "wrapped: $bin"
        count=$((count + 1))
      }

      if [ "$#" -gt 0 ]; then
        for d in "$@"; do wrap_one "$d"; done
      else
        for d in "$unity_root"/*/Editor; do
          if [ -e "$d/Unity" ]; then wrap_one "$d"; fi
        done
      fi

      if [ "$count" -eq 0 ]; then
        echo "No Unity editors wrapped under $unity_root." >&2
        echo "Install one with Unity Hub, then re-run, or pass editor dirs:" >&2
        echo "  wrap-unity-steam $unity_root/<version>/Editor" >&2
        exit 1
      fi
    '')
  ];
}
