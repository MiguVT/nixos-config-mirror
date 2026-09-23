{ ... }:

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
      uuid = "513eb2ba-a73f-4a0e-a6fd-cd169cf7393d";
      # token: injected from a systemd credential, never stored in the Nix store
    };

    # Exposed at /run/secrets/forgejo_token by sops-nix, loaded via LoadCredential
    secrets.server.connections.default.token_url = "/run/secrets/forgejo_token";
  };

  # The NixOS runner module uses the host Podman API for docker-labeled jobs.
  # Keep the runner process sandboxed; only register trusted repositories until
  # the jobs are moved to a separately isolated runtime.
  systemd.services.forgejo-runner-default.serviceConfig = {
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateTmp = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectSystem = "strict";
    RestrictSUIDSGID = true;
    LockPersonality = true;
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_INET"
      "AF_INET6"
      "AF_NETLINK"
    ];
  };
}
