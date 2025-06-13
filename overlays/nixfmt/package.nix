self: super: {
  nixfmt-rfc-style =
    let
      inherit (self.haskell.lib.compose) overrideCabal justStaticExecutables;

      overrides = rec {
        version = "unstable-${self.lib.fileContents ./date.txt}";

        passthru.updateScript = ./update.sh;
        teams = [ self.lib.teams.formatter ];

        preBuild = ''
          echo -n 'nixpkgs-${version}' > .version
        '';

        passthru.tests =
          self.runCommand "nixfmt-rfc-style-tests" { nativeBuildInputs = [ self.nixfmt-rfc-style ]; }
            ''
              nixfmt --version > $out
            '';
      };

      raw-pkg = self.haskellPackages.callPackage ./generated-package.nix { };
    in
    self.lib.pipe raw-pkg [
      (overrideCabal overrides)
      justStaticExecutables
    ];
}
