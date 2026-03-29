{ inputs, ... }:
{
  flake.nixosModules.home-manager =
    { pkgs, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      home-manager = {
        # Shared Home Manager modules
        sharedModules = [
          inputs.sops-nix.homeManagerModules.sops
        ];

        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };
}
