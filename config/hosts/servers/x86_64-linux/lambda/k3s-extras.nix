{ ... }:
{
  services.k3s = {
    nodeLabel = [
      "services/gaming=true"
      "services/minecraft=true"
    ];
    nodeTaint = [
      "minecraft-dedicated=true:NoSchedule"
    ];
  };
}
