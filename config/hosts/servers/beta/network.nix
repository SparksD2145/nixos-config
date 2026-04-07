{ ... }:
{
  networking = {
    useDHCP = false;

    interfaces.eno1.useDHCP = true;
    interfaces.eno2.useDHCP = true;
    interfaces.br0.useDHCP = true;

    bridges = {
      "br0" = {
        interfaces = [ "eno1" ];
      };
    };
  };
}
