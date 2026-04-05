{ ... }:
{
  # Enable a bridge network for VM access.
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    netdevs = {
      "30-br0" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br0";
          MACAddress = "b4:2e:99:33:ab:15";
        };
      };
    };
    networks = {
      "30-enp7s0" = {
        name = "enp7s0";
        bridge = [ "br0" ];
      };
      "30-br0" = {
        name = "br0";
        DHCP = "yes";
        # dhcpV4Config = {
        #   UseDomains = true;
        # };
      };
    };
    links = {
      "30-br0" = {
        matchConfig = {
          OriginalName = "br0";
        };
      };
    };
  };

  # networking.useDHCP = false;
  # networking.interfaces."enp7s0".useDHCP = true;
  # networking.interfaces."br0".useDHCP = true;
  # networking.bridges = {
  #   br0 = {
  #     interfaces = [
  #       "enp7s0"
  #     ];
  #   };
  # };

  networking.firewall.trustedInterfaces = [
    "br0"
  ];
}
