{ pkgs, ... }:
{
  # Let there be games
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraProfile = ''
        # Fixes timezones on VRChat
        unset TZ
        # Allows Monado to be used
        export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
      '';
    };
  };

  # Minecraft Launcher
  environment.systemPackages = with pkgs; [
    prismlauncher
  ];
}
