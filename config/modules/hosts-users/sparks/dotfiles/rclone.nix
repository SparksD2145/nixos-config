{
  inputs,
  config,
  ...
}:
{
  home-manager.users.sparks.programs.rclone = {
    enable = true;

    remotes = {
      "omega.sparks.codes" = {
        config = {
          type = "sftp";
          host = "omega.sparks.codes";
        };

        secrets.password = config.sops.secrets."users/sparks/rclone_pass".path;
      };
      "tango.sparks.codes" = {
        config = {
          type = "sftp";
          host = "tango.sparks.codes";
        };

        secrets.password = config.sops.secrets."users/sparks/rclone_pass".path;
      };
    };
  };

  sops.secrets = {
    "users/sparks/rclone_pass" = { };
  };
}
