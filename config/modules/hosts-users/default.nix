{ ... }:
{
  flake.nixosModules.hosts-users =
    { ... }:
    {
      imports = [
        # Root user (for emergency access)
        ./root/user.nix

        # Regular users
        ./sparks/user.nix
      ];
    };
}
