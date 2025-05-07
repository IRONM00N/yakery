{ pkgs, ... }:

with pkgs;
[
  coreutils
  findutils
  diffutils
  gawk
  gnused
  gnugrep
  util-linux
  binutils
  tree
  git
  delta
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
