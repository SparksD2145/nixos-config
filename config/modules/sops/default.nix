{
  # This will add secrets.yml to the nix store
  # You can avoid this by adding a string to the full path instead, i.e.
  # sops.defaultSopsFile = "/root/.sops/secrets/example.yaml";
  defaultSopsFile = ./secrets.sops.yaml;

  # This will automatically import SSH keys as age keys
  age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # This is using an age key that is expected to already be in the filesystem
  # age.keyFile = "/var/lib/sops-nix/key.txt";

  # This will generate a new key if the key specified above does not exist
  # age.generateKey = true;

  # This is the actual specification of the secrets.
  secrets.test_data = { };
  # secrets."myservice/my_subdir/my_secret" = { };
}
