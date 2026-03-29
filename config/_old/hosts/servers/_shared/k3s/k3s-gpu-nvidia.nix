{ pkgs, ... }:
{
  # Install the nvidia-container-toolkit package to enable GPU support in containers
  environment.systemPackages = with pkgs; [
    nvidia-container-toolkit
  ];

  # Enable the nvidia-container-toolkit and mount the nvidia executables into the container
  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia-container-toolkit.mount-nvidia-executables = true;

  # Enable the nvidia driver and settings
  hardware.nvidia = {
    open = true;
    nvidiaSettings = true;
  };

  # Enable the nvidia driver for graphics and 32-bit support
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Hack for getting the nvidia driver recognized
  services.xserver = {
    enable = false;
    videoDrivers = [ "nvidia" ];
  };

  # Allow unfree packages for the nvidia driver and settings
  nixpkgs.config.allowUnfreePackages = [
    "nvidia-x11"
    "nvidia-settings"
  ];

  # Configure containerd to use the nvidia-container-runtime for GPU support in containers
  services.k3s.containerdConfigTemplate = ''
    {{ template "base" . }}

    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia]
      privileged_without_host_devices = false
      runtime_engine = ""
      runtime_root = ""
      runtime_type = "io.containerd.runc.v2"

    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.nvidia.options]
      BinaryName = "${pkgs.nvidia-container-toolkit.tools}/bin/nvidia-container-runtime.cdi"
  '';
}
