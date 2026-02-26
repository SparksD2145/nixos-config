{ inputs, system, ... }:
[
  # SOPS-NIX module for managing secrets
  inputs.sops-nix.nixosModules.sops
  { sops = import ./sops; }

  # Home Manager module for managing user configuration
  inputs.home-manager.nixosModules.home-manager
  { home-manager = import ./home-manager { inherit inputs system; }; }

  # Use GitOps configuration
  inputs.comin.nixosModules.comin
  ({
    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = "https://github.com/SparksD2145/nixos-config.git";
          poller.period = 900; # Poll every 15 minutes
        }
      ];
    };
  })
]
