{ ... }:
{
  # Enable a bridge network for VM access.
  networking.interfaces."enp7s0".useDHCP = false;
  networking.interfaces."br0".useDHCP = true;
  networking.bridges = {
    br0 = {
      interfaces = [
        "enp7s0"
      ];
    };
  };
}
