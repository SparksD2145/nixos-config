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
  # List of users to configure
  sparks = import ./sparks/home-manager { inherit inputs pkgs; };
}
