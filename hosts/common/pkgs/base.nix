{ pkgs, ... }:

with pkgs;
[
  busybox
  binutils
  git
  gnumake
  wget
  htop
  gnupg

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

  nmap
  wireshark
]
