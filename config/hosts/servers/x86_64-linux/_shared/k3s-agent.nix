{ ... }:
{
  services.k3s = {
    enable = true;
    role = "agent";

    serverAddr = "https://sierra.sparks.codes:6443";
  };
}
