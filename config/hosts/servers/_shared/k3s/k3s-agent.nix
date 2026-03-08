{ config, lib, ... }:
{
  services.k3s = {
    enable = true;
    role = "agent";

    serverAddr = "https://10.10.1.11:6443";

    tokenFile = config.sops.secrets."k3s/node-token".path;
  };

  networking.firewall.enable = false;

  systemd.services.containerd.serviceConfig = {
    LimitNOFILE = lib.mkForce null;
  };
}
