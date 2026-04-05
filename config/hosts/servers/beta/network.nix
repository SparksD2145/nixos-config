{ ... }:
{
  # Enable a bridge network for VM access.
  networking.networkmanager.enable = false;
  networking.useDHCP = false;
  networking.interfaces."enp7s0".useDHCP = true;
  networking.interfaces."br0".useDHCP = true;
  networking.bridges = {
    br0 = {
      interfaces = [
        "enp7s0"
      ];
    };
  };

  networking.firewall.trustedInterfaces = [
    "lo"
    "br0"
  ];
}
