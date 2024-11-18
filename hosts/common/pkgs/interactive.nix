{ pkgs, ... }:

let
  base-pkgs = import ./base.nix { inherit pkgs; };
in
base-pkgs
++ (with pkgs; [
  qemu
  emacs
  helix
  vscode.fhs # use the built-in settings sync
  zed-editor

  exiftool
  hashcat
  john # the ripper
  hash-identifier
  netcat
  binwalk
  zsteg
  steghide
  sonic-visualiser

  usbmuxd

  wl-clipboard
  git-filter-repo
  rustup

  os-prober
])
