{
  inputs,
  ...
}:
let
  system = "aarch64-linux";
  applySharedModules =
    { inputs, system }:
    [
      # Shared system configuration across all hosts
      ../../_global
      ./shared

      # SOPS-NIX module for managing secrets
      inputs.sops-nix.nixosModules.sops
      { sops = import ../../../modules/sops; }

      # Home Manager module for managing user configuration
      inputs.home-manager.nixosModules.home-manager
      { home-manager = import ../../../modules/home-manager { inherit inputs system; }; }

      # Import users for home-manager
      ../../../users/home-manager.nix
    ];
in
{
  flake.nixosConfigurations = {
    "rpi4-poe-1" = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        # System-specific configurations
        ./rpi4-poe-1
      ]
      ++ applySharedModules { inherit inputs system; };
    };
    "rpi4-poe-2" = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        # System-specific configurations
        ./rpi4-poe-2
      ]
      ++ applySharedModules { inherit inputs system; };
    };
    "rpi4-poe-3" = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        # System-specific configurations
        ./rpi4-poe-3
      ]
      ++ applySharedModules { inherit inputs system; };
    };
  };
}
