{ pkgs, config, ... }:
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

  # VR Configuration
  services.monado = {
    enable = true;
    defaultRuntime = true; # Register as default OpenXR runtime
  };
  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
    XRT_COMPOSITOR_USE_PRESENT_WAIT = "1";
    U_PACING_COMP_TIME_FRACTION_PERCENT = "90";
  };
  home-manager.users.sparks.home.file.".config/openxr/1/active_runtime.json".source =
    "${pkgs.monado}/share/openxr/1/openxr_monado.json";

  home-manager.users.sparks.home.file.".config/openvr/openvrpaths.vrpath" = {
    force = true;
    text =
      let
        steam = "/home/sparks/.local/share/Steam";
      in
      builtins.toJSON {
        version = 1;
        jsonid = "vrpathreg";

        external_drivers = null;
        config = [ "${steam}/config" ];

        log = [ "${steam}/logs" ];

        "runtime" = [
          "${pkgs.xrizer}/lib/xrizer"
        ];
      };
  };
}
