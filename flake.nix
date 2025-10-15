{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # Home Manager, used for managing user configurations
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sops-nix, used for managing secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-flatpak, used for declaratively managing flatpaks
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";

    # flake-parts, used for modularizing NixOS configurations
    # flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    {
      nixosConfigurations = import ./config/hosts { inherit inputs; };
    };
}
