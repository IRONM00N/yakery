# This file has been autogenerate with cabal2nix.
# Update via ./update.sh
{
  mkDerivation,
  base,
  bytestring,
  cmdargs,
  directory,
  fetchzip,
  file-embed,
  filepath,
  lib,
  megaparsec,
  mtl,
  parser-combinators,
  pretty-simple,
  process,
  safe-exceptions,
  scientific,
  text,
  transformers,
  unix,
}:
mkDerivation {
  pname = "nixfmt";
  version = "0.6.0";
  src = fetchzip {
    url = "https://github.com/ironm00n/nixfmt/archive/7249ea89cd3a9105d047583ef02ab5883250c874.tar.gz";
    sha256 = "0gigwb37m457b3l9kh4jgp757amsslpkn0izds6nwzadysf40f6h";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base
    megaparsec
    mtl
    parser-combinators
    pretty-simple
    scientific
    text
    transformers
  ];
  executableHaskellDepends = [
    base
    bytestring
    cmdargs
    directory
    file-embed
    filepath
    process
    safe-exceptions
    text
    transformers
    unix
  ];
  jailbreak = true;
  homepage = "https://github.com/NixOS/nixfmt";
  description = "Official formatter for Nix code";
  license = lib.licenses.mpl20;
  mainProgram = "nixfmt";
}
