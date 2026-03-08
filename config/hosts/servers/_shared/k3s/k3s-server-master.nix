{ config, lib, ... }:
{
  services.k3s = {
    enable = true;
    role = "server";

    clusterInit = true;
    tokenFile = config.sops.secrets."k3s/node-token".path;

    disable = [
      "traefik"
      "servicelb"
      "local-storage"
      "metrics-server"
    ];
  };

  networking.firewall.enable = false;

  systemd.services.containerd.serviceConfig = {
    LimitNOFILE = lib.mkForce null;
  };
}
