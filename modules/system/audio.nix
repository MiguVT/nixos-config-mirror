{ ... }:

{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    wireplumber.extraConfig = {
      "10-disable-headset-profile-switch" = {
        "wireplumber.settings" = {
          # Prevents switching to terrible-sounding mono mode when games/Discord start
          "bluetooth.autoswitch-to-headset-profile" = false;
        };
      };
    };
  };
}
