args@{ config, pkgs, ... }:
{
  imports = [
    (import ./all.nix args)
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  networking.hostName = config.host.hostname;

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  environment.systemPackages = import ./pkgs/networked.nix args;
}
