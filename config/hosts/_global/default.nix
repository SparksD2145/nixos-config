{
  pkgs,
  ...
}:
{
  imports = [
    ./i18n.nix
    ./nixos.nix
  ];

  # Globally installed system packages.
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    tmux
    usbutils
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # enable shells
  programs.zsh.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };

  # Fuse filesystem that returns symlinks to executables based on the PATH of the requesting process. This is useful to execute shebangs on NixOS that assume hard coded locations in locations like /bin or /usr/bin etc.
  services.envfs.enable = true;

  # Enable user management by nixos-rebuild. Disable manual user management.
  users.mutableUsers = false;

  # Emergency root access
  users.users.root.hashedPassword = "$y$j9T$mZv53PR0as3i.6dnZQRYM/$0YiDLd/uErThTEb4pkx2nQh/hPmTzsDBRmWHSrqsEB/";
}
