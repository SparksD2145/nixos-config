{
  inputs,
  config,
  ...
}:
{
  sops.secrets = {
    "users/sparks/ntfy_config" = {
      neededForUsers = true;
      mode = "0440";
      owner = config.users.users.sparks.name;
      group = config.users.users.sparks.group;
      path = "/home/sparks/ntfy/client.yml";
      format = "yaml";
    };
  };
}
