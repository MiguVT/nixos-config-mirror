{ pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = with pkgs; [
      virtiofsd # Virtio-fs shared folders
    ];
  };

  programs.virt-manager.enable = true;

  # Required for DNS/DHCP on the default libvirt network (virbr0)
  environment.systemPackages = with pkgs; [
    dnsmasq
  ];

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # Needed to manage the qemu:///system connection as a non-root user
  users.users."miguvt".extraGroups = [ "libvirtd" ];
}
