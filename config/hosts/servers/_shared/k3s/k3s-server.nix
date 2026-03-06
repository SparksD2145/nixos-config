{ config, ... }:
{
  services.k3s = {
    enable = true;
    role = "server";

    cluster-init = (if config.hostName == "sierra" then true else false);
    serverAddr = "https://sierra.sparks.codes:6443";

    tokenFile = config.sops.secrets."k3s/node-token".path;
    agentTokenFile = config.sops.secrets."k3s/node-token".path;

    disable = [
      "traefik"
      "servicelb"
      "local-storage"
      "metrics-server"
    ];
  };
}
