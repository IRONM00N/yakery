{ pkgs, ... }:

with pkgs;
[
  busybox
  binutils
  git
  gnumake
  htop
  gnupg
  ripgrep

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
]
