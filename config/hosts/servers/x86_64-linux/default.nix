{
  inputs,
  ...
}:
let
  system = "x86_64-linux";
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
    "sierra" = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        # System-specific configurations
        ./sierra
      ]
      ++ applySharedModules { inherit inputs system; };
    };
    "romeo" = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        # System-specific configurations
        ./romeo
      ]
      ++ applySharedModules { inherit inputs system; };
    };
    "xray" = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        # System-specific configurations
        ./xray
      ]
      ++ applySharedModules { inherit inputs system; };
    };
    "tango" = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        # System-specific configurations
        ./tango
      ]
      ++ applySharedModules { inherit inputs system; };
    };
    "lambda" = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        # System-specific configurations
        ./lambda
      ]
      ++ applySharedModules { inherit inputs system; };
    };
  };
}
