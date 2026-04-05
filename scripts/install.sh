# Accept hostname as an argument
if [ -z "$1" ]; then
    system_hostname = $1
else
    exit 1;
fi

# INSTALL
sudo nixos-install --root /mnt --flake "github:SparksD2145/nixos-config#${system_hostname}"
