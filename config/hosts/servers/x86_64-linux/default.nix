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

    ]
    ++ (import ../../../modules { inherit inputs system; });
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
