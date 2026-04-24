{ self, inputs, ... }:
{

  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    {
      environment.variables.NIXOS_OZONE_WL = "1";

      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
      };

      environment.systemPackages = with pkgs; [
        kitty
        mako
        gnome-keyring
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
        fuzzel
        kdePackages.polkit-kde-agent-1
        xwayland-satellite
        swaylock
      ];

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
            "/usr/lib/pam_kwallet_init"
          ];

          environment = {
            "NIXOS_OZONE_WL" = "1";
            "ELECTRON_OZONE_PLATFORM_HINT" = "wayland";
            "OZONE_PLATFORM" = "wayland";
          };

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          input.keyboard.xkb.layout = "us,ua";

          input.touchpad = {
            natural-scroll = { };
            click-method = "clickfinger";
          };

          layout.gaps = 5;

          binds = {
            # General
            "Mod+Shift+Slash".show-hotkey-overlay = { };
            "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
            "Super+Alt+L".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call lockScreen lock";
            "Mod+Tab".toggle-overview = { };
            "Control+Alt+Delete".quit = { };

            # Window Management
            "Mod+Q".close-window = { };
            "Mod+F".maximize-column = { };
            "Mod+Shift+F".maximize-window-to-edges = { };

            # System Management
            "XF86AudioRaiseVolume".spawn-sh =
              "${lib.getExe self'.packages.myNoctalia} ipc call volume increase";
            "XF86AudioLowerVolume".spawn-sh =
              "${lib.getExe self'.packages.myNoctalia} ipc call volume decrease";
            "XF86AudioMute".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call volume muteOutput";

            "XF86AudioPlay".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call media playPause";

            "XF86MonBrightnessUp".spawn-sh =
              "${lib.getExe self'.packages.myNoctalia} ipc call brightness increase";
            "XF86MonBrightnessDown".spawn-sh =
              "${lib.getExe self'.packages.myNoctalia} ipc call brightness decrease";

            # Noctalia binds
            "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
            "Mod+Period".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call controlCenter toggle";
            "Mod+Comma".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call settings open";

            # Navigation
            "Mod+Left".focus-column-left = { };
            "Mod+Down".focus-window-down = { };
            "Mod+Up".focus-window-up = { };
            "Mod+Right".focus-column-right = { };
            "Mod+Ctrl+Left".move-column-left = { };
            "Mod+Ctrl+Down".move-window-down = { };
            "Mod+Ctrl+Up".move-window-up = { };
            "Mod+Ctrl+Right".move-column-right = { };
            "Mod+Home".focus-column-first = { };
            "Mod+End".focus-column-last = { };
            "Mod+Ctrl+Home".move-column-to-first = { };
            "Mod+Ctrl+End".move-column-to-last = { };
            "Mod+Shift+Left".focus-monitor-left = { };
            "Mod+Shift+Down".focus-monitor-down = { };
            "Mod+Shift+Up".focus-monitor-up = { };
            "Mod+Shift+Right".focus-monitor-right = { };
            "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = { };
            "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = { };
            "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = { };
            "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = { };
            "Mod+Page_Down".focus-workspace-down = { };
            "Mod+Page_Up".focus-workspace-up = { };
            "Mod+U".focus-workspace-down = { };
            "Mod+I".focus-workspace-up = { };
            "Mod+Ctrl+Page_Down".move-column-to-workspace-down = { };
            "Mod+Ctrl+Page_Up".move-column-to-workspace-up = { };
            "Mod+Ctrl+U".move-column-to-workspace-down = { };
            "Mod+Ctrl+I".move-column-to-workspace-up = { };
            "Mod+Shift+Page_Down".move-workspace-down = { };
            "Mod+Shift+Page_Up".move-workspace-up = { };
            "Mod+Shift+U".move-workspace-down = { };
            "Mod+Shift+I".move-workspace-up = { };
          };
        };
      };
    };
}
