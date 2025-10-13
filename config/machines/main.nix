{
  inputs,
  ...
}:
{
  "alpha" = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      # System Configuration
      ./shared.nix
      ./alpha/configuration.nix

      # SOPS-NIX module for managing secrets
      inputs.sops-nix.nixosModules.sops

      # Home Manager module for managing user configuration
      inputs.home-manager.nixosModules.home-manager
      { home-manager = import ../modules/home-manager/main.nix; }
    ];
  };
}
