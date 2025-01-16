{ ... }:
{
  projectRootFile = "flake.nix";
  settings.global.excludes = [
    ".envrc"
    "*.opam"
    "*.zip"
    "*.tar.gz"
  ];
  programs = {
    deadnix.enable = false;
    nixfmt.enable = true;
    jsonfmt.enable = true;
    mdformat.enable = true;
  };
}
