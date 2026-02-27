{ pkgs, ... }:
{
  plugins = with pkgs; [
    networkmanager-openvpn
  ];
}
