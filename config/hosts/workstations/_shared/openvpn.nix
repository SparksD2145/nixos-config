{ pkgs, ... }:
{
  # Add openvpn support to networkmanager.
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];
}
