{ pkgs, ... }:

let
  base-pkgs = import ./base.nix { inherit pkgs; };
in
base-pkgs
++ (with pkgs; [
  inetutils

  wget
  nmap
  wireshark
  dig

  # sets up server for remote development
  vscode-extensions.ms-vscode-remote.remote-ssh
])
