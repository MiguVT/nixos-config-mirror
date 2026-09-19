{ config, ... }:

{
  # age identity derived from the sops-dedicated ed25519 key
  # (private key: /home/miguvt/.ssh/id_ed25519_bw, also stored in Bitwarden).
  # Edit secrets: sops secrets/secrets.yaml (from the flake dev shell)
  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.age.keyFile = "/home/miguvt/.config/sops/age/keys.txt";

  sops.secrets.example-key = { };
}
