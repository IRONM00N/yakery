{ config, ... }:
{
  imports = [
    ./all.nix
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  networking.hostName = config.host.hostname;
}
