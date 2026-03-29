{
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix

    # K3s server configuration.
    ../../_shared/k3s/k3s-coral.nix
    ../../_shared/k3s/k3s-agent.nix
    ../../_shared/k3s/k3s-gpu-intel.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "whiskey"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
