{ config, pkgs, lib, ... }:


{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;

      extraConfig = {
        "10-restore" = {
          "wireplumber.settings" = {
            "restore-state" = true;
          };
        };
      };
    };
  };


}

