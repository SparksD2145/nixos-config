{ ... }:
{
  # Enable Automatic optimization of nix store.
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "14:00" ];

  # Enable Automatic optimization of nix store at build.
  nix.settings.auto-optimise-store = true;

  # Enable Automatic garbage collection of nix store.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  # Enable nix-command and flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
