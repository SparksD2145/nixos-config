{ config, pkgs, ... }:
{
  networking.networkmanager = {
    enable = true;

    plugins = with pkgs; [
      networkmanager-openvpn
    ];

    ensureProfiles = {
      environmentFiles = [ config.sops.secrets."networking/wireless.conf".path ];
      profiles = {
        home-wifi = {
          connection.id = "home-wifi";
          connection.type = "wifi";
          wifi.ssid = "$HOME_SSID";
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$HOME_PSK";
          };
        };
        hotspot-wifi = {
          connection.id = "hotspot-wifi";
          connection.type = "wifi";
          wifi.ssid = "$HOTSPOT_SSID";
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$HOTSPOT_PSK";
          };
        };
      };
    };
  };
}
