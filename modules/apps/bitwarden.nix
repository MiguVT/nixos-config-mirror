{ ... }:

{
  # Expose the Bitwarden SSH agent socket to the whole user session so every
  # program (Dolphin/SFTP via KSSH, ssh, ...) prompts for the YubiKey.
  # sessionVariables is written to /etc/pam/environment (read by pam_env in the
  # login session), which the logind session inherits and thus reaches GUI apps;
  # $HOME is auto-converted to @{HOME} for PAM.
  environment.sessionVariables = {
    SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
  };

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
