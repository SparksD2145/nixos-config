{ config, ... }:
{
  services.k3s = {
    enable = true;
    role = "agent";

    serverAddr = "https://sierra.sparks.codes:6443";

    tokenFile = config.sops.secrets."k3s/node-token".path;
  };
}
