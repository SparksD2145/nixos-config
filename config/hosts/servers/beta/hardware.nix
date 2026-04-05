{
  config,
  lib,
  pkgs,
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
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9300aae7-841f-4598-b124-8c15b4f365f2";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B549-0102";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  boot.swraid.enable = true;
  boot.swraid.mdadmConf = ''
    MAILADDR root
    ARRAY /dev/md0 metadata=1.2 UUID=0e3029b9:32ff4b98:f9dfa3c4:bd2ebb54
  '';
  fileSystems."/mnt/local" = {
    device = "/dev/md0";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
