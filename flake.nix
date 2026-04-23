{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Home Manager, used for managing user configurations
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # sops-nix, used for managing secrets
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # nix-flatpak, used for declaratively managing flatpaks
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    # flake-parts, used for modularizing NixOS configurations
    flake-parts.url = "github:hercules-ci/flake-parts";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    # import-tree, used to import modularized configurations
    import-tree.url = "github:vic/import-tree";

    # comin, used for managing gitops configurations
    comin.url = "github:nlewo/comin";
    comin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      ...
    }@inputs:

    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      inputs.import-tree.match ".*/default\.nix" ./config
    );
}
