{ inputs, ... }:
{
  # Shared Home Manager modules
  sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  useGlobalPkgs = true;
  useUserPackages = true;
}
