{ pkgs, ... }:

let
  base-pkgs = import ./base.nix { inherit pkgs; };
in
base-pkgs
++ (with pkgs; [
  wget
  nmap
  wireshark

  # sets up server for remote development
  vscode-extensions.ms-vscode-remote.remote-ssh
])
