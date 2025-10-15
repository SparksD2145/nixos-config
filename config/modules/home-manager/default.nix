{ inputs, system, ... }:
{

  sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  useGlobalPkgs = true;
  useUserPackages = true;
  users = import ../../users/home-manager.nix { inherit inputs system; };
}
