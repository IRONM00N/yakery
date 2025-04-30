# upstream:
# - https://github.com/jdecked/twemoji
# - https://github.com/mozilla/twemoji-colr
# uses pkgs-stable to avoid excessive rebuilds
{ pkgs-stable, ... }:

let
  twemoji = pkgs-stable.fetchFromGitHub {
    name = "twemoji";
    owner = "IRONM00N";
    repo = "twemoji";
    rev = "044e4a8ae646bab4ade3c198ab980560c8f09168";
    hash = "sha256-RrM9r8HNekzesR4IsdfZQquWWHPNarSWJLOlwtymCrU=";
  };

  # changes in fork:
  # - change FONT_NAME to "Twemoji COLR" in Makefile
  # - change font name Gruntfile.js
  # - update package-lock.json to have `integrity` and `resolved` fields
  twemoji-colr = pkgs-stable.fetchFromGitHub {
    name = "twemoji-colr";
    owner = "IRONM00N";
    repo = "twemoji-colr";
    rev = "b2f2b905de0d484336e4de8859f449afa111f089";
    hash = "sha256-iRHtmyCEzGYS1US4uB2laTmC6OhYO0FL0tJ/O1xhxcs=";
  };
in
pkgs-stable.buildNpmPackage (final: {
  pname = "twemoji-colr";
  version = "15.1.1";

  srcs = [
    twemoji
    twemoji-colr
  ];

  sourceRoot = twemoji-colr.name;

  npmDepsHash = "sha256-fZ5Xd70r0t6WMjkAYCktasAuvif0KIIMz6L1Swvznpc=";

  nativeBuildInputs = with pkgs-stable; [
    nodejs
    node-gyp
    pkg-config
    fontforge
    python3Packages.fonttools
    python3Packages.distutils
    zip
    unzip
    which
    perl
  ];

  buildInputs = with pkgs-stable; [
    pixman
    cairo
    pango
  ];

  buildPhase = ''
    runHook preBuild

    zip -r twe-svg.zip ../twemoji/assets/svg
    make
    mv "build/Twemoji COLR.ttf" build/twemoji-colr.ttf

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 build/twemoji-colr.ttf $out/share/fonts/truetype/twemoji-colr.ttf

    runHook postInstall
  '';
})
