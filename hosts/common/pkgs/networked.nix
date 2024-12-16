{ pkgs, ... }:

let
  base-pkgs = import ./base.nix { inherit pkgs; };
in
base-pkgs
++ (with pkgs; [
  wget
  nmap
  wireshark
])
