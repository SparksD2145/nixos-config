{ ... }:
{
  imports = [
    # Root user (for emergency access)
    ./root

    # Regular users
    ./sparks
  ];
}
