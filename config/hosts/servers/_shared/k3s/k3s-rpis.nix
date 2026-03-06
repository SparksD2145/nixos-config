{ ... }:
{
  services.k3s = {

    # Taint this node to prevent scheduling of pods that require more resources than the RPi can provide.
    nodeTaint = [
      "low-memory=true:NoSchedule"
    ];
  };
}
