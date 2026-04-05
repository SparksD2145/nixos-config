{ ... }:
{
  # Enable a bridge network for VM access.
  networking = {
    networkmanager.enable = false;
    useNetworkd = true;
    bridges.br0.interfaces = [ "enp7s0" ];
    interfaces.br0 = {
      useDHCP = true;
    };

    firewall.trustedInterfaces = [
      "lo"
      "br0"
    ];
  };

  systemd.services.dhcpcd.after = [ "sys-subsystem-net-devices-br0.device" ];
}
