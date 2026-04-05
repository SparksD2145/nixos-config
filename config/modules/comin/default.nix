{ inputs, ... }:
{
  flake.nixosModules.comin =
    { pkgs, ... }:
    {
      imports = [
        inputs.comin.nixosModules.comin
      ];

      services.comin = {
        enable = true;
        remotes = [
          {
            name = "origin";
            url = "https://github.com/SparksD2145/nixos-config.git";
            branches.main.name = "master";
            poller.period = 900; # Poll every 15 minutes
            auth.access_token_path = "/run/secrets/comin/gh_token";
          }
          {
            name = "gitlab";
            url = "https://gitlab.iwrite.software/sparks/nixos-config.git";
            branches.main.name = "master";
            poller.period = 30; # Poll every 30 seconds
            auth.access_token_path = "/run/secrets/comin/glab_token";
          }
        ];
      };

      sops = {
        secrets."comin/gh_token" = { };
        secrets."comin/glab_token" = { };
      };
    };
}
