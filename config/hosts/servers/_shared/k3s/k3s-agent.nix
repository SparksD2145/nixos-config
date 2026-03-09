{ config, lib, ... }:
{
  # K3s agent configuration
  services.k3s = {
    enable = true;
    role = "agent";
    serverAddr = "https://10.10.1.11:6443";
    tokenFile = config.sops.secrets."k3s/node-token".path;
  };

  # Disable the firewall, as K3s will manage it.
  networking.firewall.enable = false;

  # Workaround for rook-ceph on nixos
  systemd.services.containerd.serviceConfig = {
    LimitNOFILE = lib.mkForce null;
  };
}
