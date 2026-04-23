{ inputs, ... }:
{
  flake.nixosModules.k3s-gpu-intel =
    { ... }:
    {
      # Intel GPU drivers
      services.xserver.videoDrivers = [ "i915" ];
    };
}
