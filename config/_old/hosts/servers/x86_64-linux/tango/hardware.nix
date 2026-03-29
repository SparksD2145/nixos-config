{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "mpt3sas"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "rbd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  # Enable software RAID for the local storage array.
  boot.swraid.enable = true;
  boot.swraid.mdadmConf = ''
    MAILADDR root
    ARRAY /dev/md0 metadata=1.2 UUID=82dc7ed3:fb8c1b85:43715eb4:3fa9797c
    ARRAY /dev/md1 metadata=1.2 spares=1 UUID=99782a41:fe0361a2:e9e13ed4:a2c640d1
  '';
  fileSystems."/mnt/local" = {
    device = "/dev/md0";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };
  fileSystems."/mnt/local2" = {
    device = "/dev/md1";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
