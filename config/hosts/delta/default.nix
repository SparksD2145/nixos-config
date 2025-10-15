# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{
  pkgs,
  inputs,
  config,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
    ./desktop.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "delta"; # Define your hostname.

  networking.networkmanager = {
    enable = true;
    ensureProfiles = {
      environmentFiles = [ config.sops.secrets."networking/wireless.conf".path ];
      profiles = {
        home-wifi = {
          connection.id = "home-wifi";
          connection.type = "wifi";
          wifi.ssid = "$HOME_SSID";
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$HOME_PSK";
          };
        };
        hotspot-wifi = {
          connection.id = "hotspot-wifi";
          connection.type = "wifi";
          wifi.ssid = "$HOTSPOT_SSID";
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$HOTSPOT_PSK";
          };
        };
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flatpak
  services.flatpak = {
    enable = true;
    packages = [
      "app.freelens.Freelens"
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Include system-level user configurations
  users = import ../../users/system.nix { inherit config inputs pkgs; };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
