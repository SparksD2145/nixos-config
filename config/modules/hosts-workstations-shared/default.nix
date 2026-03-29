{ ... }:
{
  flake.nixosModules.hosts-workstations-shared =
    { ... }:
    {
      imports = [
        ./openvpn.nix
        ./wireless.nix
      ];
    };
}
