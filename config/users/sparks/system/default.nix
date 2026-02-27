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
    packages = with pkgs; [
      kdePackages.kate
      (google-chrome.override {
        commandLineArgs = [
          "--enable-features=UseOzonePlatform"
          "--ozone-platform=wayland"
        ];
      })
      # thunderbird
    ];
    shell = pkgs.zsh;

    hashedPasswordFile = config.sops.secrets."users/sparks/passwd".path;
  };
}
