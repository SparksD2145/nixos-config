{ inputs, self, ... }:
{
  flake.nixosConfigurations.whiskey = inputs.nixpkgs.lib.nixosSystem {
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

      # K3s
      self.nixosModules.k3s-agent
      self.nixosModules.k3s-gpu-intel
      self.nixosModules.k3s-coral
    ];
  };
}
