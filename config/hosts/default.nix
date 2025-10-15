{
  inputs,
  ...
}:

{
  "alpha" =
    let
      system = "x86_64-linux";
    in
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        # System Configuration
        ./shared
        ./alpha

        # SOPS-NIX module for managing secrets
        inputs.sops-nix.nixosModules.sops
        { sops = import ../modules/sops; }

        # Home Manager module for managing user configuration
        inputs.home-manager.nixosModules.home-manager
        { home-manager = import ../modules/home-manager { inherit inputs system; }; }

        # Nix-Flatpak module for managing flatpaks declaratively
        inputs.nix-flatpak.nixosModules.nix-flatpak
      ];
    };
  "delta" =
    let
      system = "x86_64-linux";
    in
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        # System Configuration
        ./shared
        ./delta

        # SOPS-NIX module for managing secrets
        inputs.sops-nix.nixosModules.sops
        { sops = import ../modules/sops; }

        # Home Manager module for managing user configuration
        inputs.home-manager.nixosModules.home-manager
        { home-manager = import ../modules/home-manager { inherit inputs system; }; }

        # Nix-Flatpak module for managing flatpaks declaratively
        inputs.nix-flatpak.nixosModules.nix-flatpak
      ];
    };
}
