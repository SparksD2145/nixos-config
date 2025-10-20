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

      # Nix-Flatpak module for managing flatpaks declaratively
      inputs.nix-flatpak.nixosModules.nix-flatpak
    ];
in
{
  "alpha" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      # System-specific configurations
      ./alpha
    ]
    ++ applySharedModules { inherit inputs system; };
  };
  "delta" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      # System-specific configurations
      ./delta
    ]
    ++ applySharedModules { inherit inputs system; };
  };
}
