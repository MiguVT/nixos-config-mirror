{ pkgs, ... }:

{
  # 1. Container Runtime (Podman)
  virtualisation.podman = {
    enable = true;
    # Aliases the docker socket so the runner can use it automatically
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # 2. Forgejo Actions Runner
  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;

    instances.default = {
      enable = true;
      name = "nixos-podman-runner";

      # Replace with your actual Forgejo server URL
      url = "https://git.miguvt.com";

      # Securely load the token from outside the world-readable Nix store
      tokenFile = "/var/lib/forgejo-runner-token.env";

      # Maps workflow 'runs-on' values to container images
      labels = [
        "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-latest"
        "nix-latest:docker://nixos/nix:latest"
      ];
    };
  };
}
