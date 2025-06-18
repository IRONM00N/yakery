{
  host,
  hm,
  pkgs,
  lib,
  ...
}:
rec {
  # FIXME: this is copied from home-manager modules/files.nix, can it be extracted?
  mkOutOfStoreSymlink =
    path:
    let
      pathStr = toString path;
      name = hm.strings.storeFileName (baseNameOf pathStr);
    in
    pkgs.runCommandLocal name { } ''ln -s ${lib.escapeShellArg pathStr} $out'';

  symlink =
    file:
    if host.out-of-store-symlinks then
      let
        path = "/etc/nixos/users/" + file;
      in
      mkOutOfStoreSymlink path
    else
      file;
}
