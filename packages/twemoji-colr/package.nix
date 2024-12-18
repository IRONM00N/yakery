# https://github.com/jdecked/twemoji
# https://github.com/mozilla/twemoji-colr
{ pkgs }:

pkgs.stdenv.mkDerivation (final: {
  pname = "twemoji-colr";
  version = "15.1.0";

  src = pkgs.fetchurl {
    url = "https://github.com/jdecked/twemoji/archive/refs/tags/v${final.version}.tar.gz";
    sha256 = "sha256-/6OSFbsU++3yl0PF57iXwKLwYHDycAnG7HFv8IADLRk=";
  };

  twemojiColrSrc = pkgs.fetchFromGitHub {
    owner = "IRONM00N"; # TODO: change back to mozilla once pr 74 is merged
    repo = "twemoji-colr";
    rev = "6a5d49565a4b2e5774bd6577fdf8716dac9f9361";
    sha256 = "sha256-n5sBDLUtMvNgPn/UTNE7Z0G1hgxxdFilHM14lmU7WvU=";
  };

  nativeBuildInputs = with pkgs; [
    nodejs
    node-gyp
    fontforge
    python3Packages.fonttools
    python3Packages.setuptools
    python3Packages.distutils
    zip
    unzip
    which
    perl
  ];

  nodeModules = builtins.path {
    name = "node_modules";
    path = ./node_modules.tar.gz;
  };

  unpackPhase = ''
    tar xvf $src
    mkdir twemoji-colr
    cp -r ${final.twemojiColrSrc}/* twemoji-colr/
    tar -xzvf ${final.nodeModules} -C twemoji-colr
  '';

  buildPhase = ''
    cd twemoji-15.1.0
    zip -r twe-svg.zip assets/svg
    mv twe-svg.zip ../twemoji-colr/
    cd ../twemoji-colr
    # patch #!/usr/bin/env node to nixpkgs node
    patchShebangs --build node_modules
    make
    mv "build/Twemoji Mozilla.ttf" build/twemoji-colr.ttf
  '';

  installPhase = ''
    install -Dm644 build/twemoji-colr.ttf $out/share/fonts/truetype/twemoji-colr.ttf
  '';
})
