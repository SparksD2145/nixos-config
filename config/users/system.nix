{
  inputs,
  config,
  system,
  ...
}:
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
  users.users = {
    sparks = import ./sparks/system { inherit config pkgs; };
  };
}
