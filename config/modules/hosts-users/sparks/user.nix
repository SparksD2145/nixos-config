{
  inputs,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./shell.nix
    ./editors.nix
    ./ntfy.nix
    ./rclone.nix
  ];

  sops.secrets."users/sparks/passwd" = {
    neededForUsers = true;
  };

  # System Configuration
  users.users.sparks = {
    isNormalUser = true;
    description = "Thomas Ibarra";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      (if config.virtualisation.docker.enable then "docker" else "")
      (if config.virtualisation.libvirtd.enable then "libvirtd" else "")
    ];

    # Set default shell
    shell = pkgs.zsh;

    # Define SSH authorized keys for this user.
    # You can also use 'ssh-import-id' to fetch keys from GitHub or other services.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAZvl1OGc2mmdcI9tTAwwdmDaV+aKeJ0mDJB3sdwnbk"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICGu/I2uiUKP5qRB7+IcXapKMyOHEJ/CE2/WPpwcmUu9"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJytfM3FKkQSR8j0TvNH4KSfXu84CotTu4o2igJbF3eo"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGeQrWCotrsgqZ8sqeRcMzVL5dov97tq5Tu0qVvJSj02"
    ];

    # Set user's password
    hashedPasswordFile = config.sops.secrets."users/sparks/passwd".path;
  };

  # Home Manager configuration
  home-manager.users.sparks = {
    home.username = "sparks";
    home.homeDirectory = "/home/sparks";

    # Packages that should be installed to the user profile.
    home.packages = builtins.concatLists [
      (import ./packages.nix { inherit inputs pkgs; })
      (
        if config.services.xserver.enable == true then
          import ./packages-gui.nix { inherit inputs pkgs; }
        else
          [ ]
      )
    ];

    # basic configuration of git
    programs.git = {
      enable = true;
      settings.user.name = "Thomas Ibarra";
      settings.user.email = "hello@iwrite.software";
      lfs.enable = true;
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.05";
  };
}
