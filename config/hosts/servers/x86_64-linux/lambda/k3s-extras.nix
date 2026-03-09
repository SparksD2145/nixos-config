{ ... }:
{
  services.k3s = {
    # Label node as a dedicated Minecraft server, so that we can schedule Minecraft workloads on it.
    nodeLabel = [
      "services/gaming=true"
      "services/minecraft=true"
    ];

    # Taint node so that only workloads with the matching toleration will be scheduled on it.
    nodeTaint = [
      "minecraft-dedicated=true:NoSchedule"
    ];
  };
}
