{ config, pkgs, lib, ... }:

let
  wp_store_json = ''
  {
    "modules": [
      {
        "name": "store-factory",
        "type": "factory",
        "args": {
          "path": "~/.local/share/wireplumber/state",
          "save_interval": 5
        }
      },
      {
        "name": "session-factory",
        "type": "factory",
        "args": {
          "restore": true
        }
      }
    ]
  }
  '';
in
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  environment.etc."wireplumber/wireplumber.conf.d/50-store.conf".text =  wp_store_json;

}
