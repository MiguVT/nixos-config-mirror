{ ... }:

{
  # Point ssh at the Bitwarden SSH agent so it prompts for the YubiKey.
  # home.sessionVariables does not reach fish (it only emits a bash-style
  # etc/profile.d file), so the variable is exported through fish instead.
  programs.fish.interactiveShellInit = ''
    set -gx SSH_AUTH_SOCK "$HOME/.bitwarden-ssh-agent.sock"
  '';

  home-manager.users.miguvt = { pkgs, ... }: {
    home.packages = with pkgs; [
      bitwarden-desktop
    ];
  };
}
