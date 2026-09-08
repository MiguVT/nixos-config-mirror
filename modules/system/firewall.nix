{ ... }:

{
  networking.firewall = {
    allowedTCPPorts = [
      16500 # Slime Rancher
    ];
    allowedUDPPorts = [
      16500 # Slime Rancher
    ];
  };
}
