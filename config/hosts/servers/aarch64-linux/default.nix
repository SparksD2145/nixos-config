{
  inputs,
  ...
}:
let
  system = "aarch64-linux";
  applySharedModules =
    { ... }:
    [
      # Shared system configuration across all hosts
      ../../_global
      ../../../users

    ]
    ++ (import ../../../modules { inherit inputs system; });
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
