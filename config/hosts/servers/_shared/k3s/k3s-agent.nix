{ config, ... }:
{
  services.k3s = {
    enable = true;
    role = "agent";

    serverAddr = "https://10.10.1.11:6443";

    tokenFile = config.sops.secrets."k3s/node-token".path;
  };
}
