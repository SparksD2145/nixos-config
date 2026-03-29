{ pkgs, ... }:
{
  # Let there be games
  programs.steam = {
    enable = true;
  };

  # Minecraft Launcher
  environment.systemPackages = with pkgs; [
    prismlauncher
  ];
}
