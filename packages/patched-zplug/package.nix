{ pkgs, ... }:

pkgs.zplug.overrideAttrs (oldAttrs: {
  dontPatch = false;
  patches = (oldAttrs.patches or [ ]) ++ [
    ./zplug.patch
  ];
  # orig uses $src
  installPhase = ''
    mkdir -p $out/share/zplug
    cp -r {autoload,base,bin,init.zsh,misc} $out/share/zplug/
    mkdir -p $out/share/man
    cp -r doc/man/* $out/share/man/
  '';
})
