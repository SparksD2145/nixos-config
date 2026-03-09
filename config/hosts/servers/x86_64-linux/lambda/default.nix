{
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix

    # Include the ZFS configuration.
    ../../_shared/zfs.nix

    # K3s agent configuration.
    ../../_shared/k3s/k3s-agent.nix
    ./k3s-extras.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_500GB_S3Z1NB0K182540Z"; # or "nodev" for efi only

  networking.hostName = "lambda"; # Define your hostname.
  networking.hostId = "8425e342"; # required for zfs, can be set to any random string, but must be unique for each machine in a cluster

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
