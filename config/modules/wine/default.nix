{ ... }:
{
  flake.nixosModules.wine =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # wine-staging (version with experimental features)
        wineWow64Packages.staging

        # winetricks (all versions)
        winetricks

        # native wayland support (unstable)
        wineWow64Packages.waylandFull
      ];
    };
}
