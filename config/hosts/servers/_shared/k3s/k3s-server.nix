{ config, ... }:
{
  services.k3s = {
    enable = true;
    role = "server";

    clusterInit = (if config.networking.hostName == "sierra" then true else false);
    serverAddr = "https://10.10.1.11:6443";

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
