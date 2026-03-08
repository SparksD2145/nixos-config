{ config, pkgs, ... }:
{
  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia-container-toolkit.mount-nvidia-executables = true;

  environment.systemPackages = with pkgs; [
    nvidia-container-toolkit
  ];

  hardware.nvidia = {
    open = true;
    nvidiaSettings = true;
  };

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Hack for getting the nvidia driver recognized
  services.xserver = {
    enable = false;
    videoDrivers = [ "nvidia" ];
  };

  nixpkgs.config.allowUnfreePackages = [
    "nvidia-x11"
    "nvidia-settings"
  ];
}
