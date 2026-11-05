{ ... }:

{
  # Yuan Da Xin MadMouse (04f3:026e / 04f3:026f): grant the logged-in desktop
  # user write access to its hidraw configuration interface, previously done
  # manually with `chmod 666 /dev/hidraw2`.
  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="04f3", ATTRS{idProduct}=="026e", TAG+="uaccess"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="04f3", ATTRS{idProduct}=="026f", TAG+="uaccess"
  '';
}
