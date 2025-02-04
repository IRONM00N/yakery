{ pkgs, ... }:

with pkgs;
[
  util-linux
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

  cachix
]
