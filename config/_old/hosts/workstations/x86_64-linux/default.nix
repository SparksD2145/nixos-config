{
  inputs,
  ...
}:
let
  system = "x86_64-linux";
  applySharedModules =
    { ... }:
    [
      # Shared system configuration across all hosts
      ../../_global
      ../../../users

      # Workstation shared
      ../_shared

    ]
    ++ (import ../../../modules { inherit inputs system; });
in
{
  flake.nixosConfigurations = {
    "alpha" = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        # System-specific configurations
        ./alpha
      ]
      ++ applySharedModules { };
    };
    "delta" = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        # System-specific configurations
        ./delta
      ]
      ++ applySharedModules { };
    };
  };
}
