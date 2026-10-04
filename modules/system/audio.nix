{ ... }:

{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig = {
      pipewire = {
        "10-rates" = {
          "context.properties" = {
            "resample.quality" = 10;
          };
        };
      };
    };
    wireplumber = {
      extraConfig = {
        "50-ldac-hq" = {
          "monitor.bluez.rules" = [
            {
              matches = [
                { "device.name" = "~bluez_card.*"; }
              ];
              actions = {
                update-props = {
                  "bluez5.a2dp.ldac.quality" = "hq";
                };
              };
            }
          ];
        };
      };
    };
  };
}
