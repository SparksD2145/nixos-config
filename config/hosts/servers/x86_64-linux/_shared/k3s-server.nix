{ config, ... }:
{
  services.k3s = {
    enable = true;
    role = "server";

    cluster-init = (if config.hostName == "sierra" then true else false);
    serverAddr = "https://sierra.sparks.codes:6443";

    disable = [
      "traefik"
      "servicelb"
      "local-storage"
      "metrics-server"
    ];
  };
}
