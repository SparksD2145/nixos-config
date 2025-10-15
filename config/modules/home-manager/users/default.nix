{ inputs, pkgs, ... }:
{
  # List of users to configure
  sparks = import ./sparks { inherit inputs pkgs; };
}
