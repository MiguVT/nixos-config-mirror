{ ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings.General = {
      # Enables battery percentage display for connected devices
      Experimental = true;
      FastConnectable = true;
    };
  };
}
