{ ... }:

{
  # age identity derived from the sops-dedicated ed25519 key
  # (private key: /home/miguvt/.ssh/id_ed25519_bw, also stored in Bitwarden).
  # Edit secrets: sops secrets/secrets.yaml (from the flake dev shell)
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  # forgejo-runner registration token (consumed by services.forgejo-runner)
  sops.secrets."forgejo_token" = { };

  # llama-server API key (consumed by systemd.services.llama-server and OpenCode)
  sops.secrets."llama_key" = {
    owner = "miguvt";
    mode = "0400";
    restartUnits = [ "llama-server.service" ];
  };
}
