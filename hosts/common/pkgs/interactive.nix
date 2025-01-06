{ pkgs, ... }:

let
  base-pkgs = import ./networked.nix { inherit pkgs; };
in
base-pkgs
++ (with pkgs; [
  qemu

  exiftool
  hashcat
  john # the ripper
  hash-identifier
  netcat
  binwalk
  zsteg
  # todo: reenable when buidable
  # steghide
  # sonic-visualiser

  usbmuxd

  wl-clipboard
  git-filter-repo
  rustup

  os-prober

  gef

  emacs-gtk
  helix
  vscode.fhs # use the built-in settings sync
  zed-editor

  kdePackages.filelight

  polkit
])
