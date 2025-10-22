{ inputs, ... }:
{

  sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  useGlobalPkgs = true;
  useUserPackages = true;
}
