{ ... }:

{
  services.mullvad-vpn = {
    enable = true;
    gui.enable = true;
    # Block all network traffic from early boot until the daemon connects,
    # matching upstream Mullvad's supported-distro configuration.
    enableEarlyBootBlocking = true;
  };
}
