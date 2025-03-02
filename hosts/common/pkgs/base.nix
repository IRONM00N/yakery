{ pkgs, ... }:

with pkgs;
[
  util-linux
  toybox
  busybox
  binutils
  git
  gnumake
  htop
  gnupg
  ripgrep
  ltrace

  gcc
  gdb
  valgrind

  zsh
  neovim
  gh

  man-pages
  tldr

  docker

  neofetch
  hyfetch

  zip
  unzip

  cachix

  fastfetch
]
