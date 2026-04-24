{ inputs, ... }:
{
  flake.nixosModules.k3s-gpu-intel =
    { pkgs, ... }:
    {
      services.xserver.videoDrivers = [ "modesetting" ];

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          # Required for modern Intel GPUs (Xe iGPU and ARC)
          intel-media-driver # VA-API (iHD) userspace

          # Optional (compute / tooling):
          intel-compute-runtime # OpenCL (NEO) + Level Zero for Arc/Xe
        ];
      };

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD"; # Prefer the modern iHD backend
      };

      # May help if FFmpeg/VAAPI/QSV init fails (esp. on Arc with i915):
      hardware.enableRedistributableFirmware = true;
      boot.kernelParams = [ "i915.enable_guc=3" ];

      # May help services that have trouble accessing /dev/dri (e.g., jellyfin/plex):
      # users.users.<service>.extraGroups = [ "video" "render" ];
    };
}
