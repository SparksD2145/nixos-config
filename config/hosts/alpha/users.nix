{ pkgs, ... }:
{
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.sparks = {
    isNormalUser = true;
    description = "Thomas Ibarra";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    packages = with pkgs; [
      kdePackages.kate
      discord-ptb
      google-chrome
      # thunderbird
    ];
    shell = pkgs.zsh;
  };
}
