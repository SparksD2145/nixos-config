{
  inputs,
  config,
  ...
}:
{
  sops.secrets = {
    "users/sparks/ntfy_config" = {
      mode = "0440";
      owner = config.users.users.sparks.name;
      group = config.users.users.sparks.group;
      path = "/home/sparks/.config/ntfy/client.yml";
      format = "yaml";
    };
  };
}
