{ inputs, ... }:
{
  flake.nixosModules.k3s-coral =
    { ... }:
    {
      # Enable coral devices
      hardware.coral.pcie.enable = true;
      hardware.coral.usb.enable = true;
    };
}
