{ pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
    ./desktop.nix
    ./games.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "alpha"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    v4l-utils
  ];

  # Enable flatpak
  services.flatpak = {
    enable = true;
    packages = [
      "app.freelens.Freelens"
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
