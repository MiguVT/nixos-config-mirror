{ ... }:

{
  services.printing.enable = true;

  # mDNS discovery for network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
