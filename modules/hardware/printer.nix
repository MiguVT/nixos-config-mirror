{ lib, ... }:

{
  services.printing.enable = true;

  # mDNS discovery for network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    settings.publish = {
      "disable-publishing" = false;
      disable-user-service-publishing = false;
      publish-addresses = true;
    };
    publish.enable = lib.mkForce null;
    publish.userServices = lib.mkForce null;
  };
}
