{ inputs, system, ... }:
let
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
    };
  };
in
{

  sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  useGlobalPkgs = true;
  useUserPackages = true;
  users = import ./users { inherit inputs pkgs; };
}
