{ config, lib, ... }:
{
  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = config.sops.secrets."k3s/node-token".path;
    serverAddr = "https://10.10.1.11:6443";

    # Disable some default K3s components that are not needed in this setup.
    disable = [
      "traefik"
      "servicelb"
      "local-storage"
      "metrics-server"
    ];
  };

  # Disable the firewall to allow K3s to manage it.
  networking.firewall.enable = false;

  # Workaround for rook-ceph on nixos
  systemd.services.containerd.serviceConfig = {
    LimitNOFILE = lib.mkForce null;
  };
}
