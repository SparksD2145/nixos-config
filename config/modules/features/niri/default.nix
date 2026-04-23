{ self, inputs, ... }:
{

  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
      };
      environment.systemPackages = with pkgs; [ kitty ];

      # Required settings
      networking.networkmanager.enable = true;
      hardware.bluetooth.enable = true;
      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;

        settings = {
          spawn-at-startup = [
            (lib.getExe self'.packages.myNoctalia)
          ];

          environment = {
            "NIXOS_OZONE_WL" = "1";
            "ELECTRON_OZONE_PLATFORM_HINT" = "wayland";
            "OZONE_PLATFORM" = "wayland";
          };

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          input.keyboard.xkb.layout = "us,ua";

          layout.gaps = 5;

          binds = {
            "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
            "Mod+Q".close-window = { };
            "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
          };
        };
      };
    };

}
