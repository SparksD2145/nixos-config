{
  pkgs,
  config,
  ...
}:
{
  users.users.sparks = {
    # Define a user account. Don't forget to set a password with 'passwd'.
    isNormalUser = true;
    description = "Thomas Ibarra";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      (if config.virtualisation.docker.enable then "docker" else "")
      (if config.virtualisation.libvirtd.enable then "libvirtd" else "")
    ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAZvl1OGc2mmdcI9tTAwwdmDaV+aKeJ0mDJB3sdwnbk"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICGu/I2uiUKP5qRB7+IcXapKMyOHEJ/CE2/WPpwcmUu9"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJytfM3FKkQSR8j0TvNH4KSfXu84CotTu4o2igJbF3eo"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGeQrWCotrsgqZ8sqeRcMzVL5dov97tq5Tu0qVvJSj02"
    ];

    hashedPasswordFile = config.sops.secrets."users/sparks/passwd".path;
  };
}
