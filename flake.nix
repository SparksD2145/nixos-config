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
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.6.0";

    # flake-parts, used for modularizing NixOS configurations
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      self,
      ...
    }@inputs:

    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./config/hosts/workstations/x86_64-linux
        ./config/hosts/servers/x86_64-linux
        # ./config/hosts/servers/aarch64-linux
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { lib, system, ... }:
        {
          # Make our overlay available to the devShell
          # "Flake parts does not yet come with an endorsed module that initializes the pkgs argument.""
          # So we must do this manually; https://flake.parts/overlays#consuming-an-overlay
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = lib.attrValues self.overlays;
            config.allowUnfree = true;
          };
        };
    };
}
