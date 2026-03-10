# Grab the public key from the ssh host key and convert it to an age key using ssh-to-age.
nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'
