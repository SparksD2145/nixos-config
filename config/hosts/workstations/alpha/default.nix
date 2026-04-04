{ inputs, self, ... }:
{
  flake.nixosConfigurations.alpha = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [
      ./configuration.nix

      # Nix-Flatpak module for managing flatpaks declaratively
      inputs.nix-flatpak.nixosModules.nix-flatpak

      # Imported NixOS Modules
      self.nixosModules.home-manager
      self.nixosModules.sops
      self.nixosModules.comin

      # Shared Host Modules
      self.nixosModules.hosts-global
      self.nixosModules.hosts-users
      self.nixosModules.hosts-workstations-shared
      self.nixosModules.libvirtd
    ];
  };
}
