{ ... }:
{
  imports = [
    ./all.nix
  ];

  # Enable networking
  networking.networkmanager.enable = true;
}
