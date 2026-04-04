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
      };
    };
  };
}
