{ pkgs, ... }:

{
  # 1. Container Runtime (Podman)
  virtualisation.podman = {
    enable = true;
    # Aliases the docker socket so the runner can use it automatically
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # 2. Forgejo Actions Runner (uses the unstable pkgs.forgejo-runner by default)
  services.forgejo-runner.instances.default = {
    enable = true;

    # Maps workflow 'runs-on' values to container images (podman runtime)
    settings.runner.labels = [
      "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-latest"
      "nix-latest:docker://nixos/nix:latest"
    ];

    settings.server.connections.default = {
      url = "https://git.miguvt.com/";
      uuid = "04053b2b-74e0-4aae-bbe2-8828f404baa0";
      # token: injected from a systemd credential, never stored in the Nix store
    };

    # Exposed at /run/secrets/forgejo_token by sops-nix, loaded via LoadCredential
    secrets.server.connections.default.token_url = "/run/secrets/forgejo_token";
  };
}
