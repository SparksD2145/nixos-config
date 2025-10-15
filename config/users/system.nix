{
  inputs,
  config,
  pkgs,
  ...
}:
{
  # List of users to configure
  users = {
    sparks = import ./sparks/system { inherit config inputs pkgs; };
  };
}
