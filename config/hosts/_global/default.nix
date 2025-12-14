{ pkgs, ... }:
{
  imports = [
    ./i18n.nix
  ];

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Enable nix-command and flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    tmux
    usbutils
  ];

  # enable shells
  programs.zsh.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Fuse filesystem that returns symlinks to executables based on the PATH of the requesting process. This is useful to execute shebangs on NixOS that assume hard coded locations in locations like /bin or /usr/bin etc.
  services.envfs.enable = true;

  # Enable user management by nixos-rebuild. Disable manual user management.
  users.mutableUsers = false;
}
