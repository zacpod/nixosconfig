{ config, pkgs, ... }:

{
  networking = {
    hostName = "Goliath";
    networkmanager.enable = true;
    hosts = {
      "10.255.255.4" = [ "gitlab.jolera.com" ];
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 24800 ];
      allowedUDPPorts = [ 24800 6980 ];
      extraCommands = ''
        			  iptables -A INPUT -p udp --sport 137 -j ACCEPT
        			  iptables -A INPUT -p udp --sport 138 -j ACCEPT
        			'';
    };
  };
}
