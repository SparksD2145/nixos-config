{ config, ... }:
{
  services.k3s = {

    extraFlags = (
      toString [
        "--container-runtime-endpoint unix:///run/containerd/containerd.sock"
      ]
    );

    label = {
      "nixos-nvidia-cdi" = "enabled";
    };
  };

  hardware.nvidia-container-toolkit.enable = true;

  virtualisation.containerd = {
    enable = true;
    settings = {
      plugins."io.containerd.grpc.v1.cri" = {
        enable_cdi = true;
        cdi_spec_dirs = [ "/var/run/cdi" ];
      };
    };
  };

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  nixpkgs.config.nvidia.acceptLicense = true;
  hardware.nvidia.datacenter.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
}
